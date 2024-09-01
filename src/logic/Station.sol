// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Cookie, CookieVendor} from "token/Cookie.sol";

import {GameMeta, IGame} from "logic/Game.sol";
import {IOracle, Oracle} from "util/Oracle.sol";
import {IGameProxy} from "util/Proxy.sol";

interface IStation {
    function depositLP(uint256 _amount) external;

    function withdrawLP(uint256 _amount) external;

    function playMulti(bytes[] calldata _data) external;
}

contract TransientLock {
    modifier NonReentrant(bytes32 key) {
        assembly {
            if tload(key) { revert(0, 0) }
            tstore(key, 1)
        }
        _;
        assembly {
            tstore(key, 0)
        }
    }

    bytes32 internal constant LOCK = keccak256("lock");
    bytes32 internal constant B_LOCK = keccak256("b");
}

contract LPVendor {
    mapping(address => uint256) internal LP;

    function getLPBalance() external view returns (uint256) {
        return LP[msg.sender];
    }

    function depositLP(uint256 _amount) external {
        // TODO : implement
    }

    function withdrawLP(uint256 _amount) external {
        // TODO : implement
    }
}

/// @dev 반드시 admin 계정을 통해서만 오라클을 설정하고 실행해야 함

contract Station is CookieVendor, Ownable {
    // stoppable
    IOracle public oracle;
    address internal gameProxy;

    mapping(uint256 => GameMeta) internal games;

    error InvalidAmount();

    // only for initial setup
    constructor(address _game) Ownable(msg.sender) {
        oracle = new Oracle();
        gameProxy = _game;
        require(cookie.balanceOf(address(this)) == type(uint256).max);
    }

    /* --- External Functions --- */

    function getGameMeta(uint256 _id) external view returns (GameMeta memory) {
        return games[_id];
    }

    function setGame(GameMeta calldata _meta) external onlyOwner {
        games[_meta.id] = _meta;
    }

    function setGame(uint256 _id, address _logic, uint256 _version, uint256 _minAmount, uint256 _maxAmount)
        external
        onlyOwner
    {
        games[_id] = createGameMeta(_id, _logic, _version, _minAmount, _maxAmount);
    }

    function claim() external {
        // TODO : 사용자가 플레이한 게임의 결과를 순회한다.
        // TODO : 정보의 블록 번호의 해시를 토대로 오라클을 통해 숫자를 가져온다.
        // TODO : 해당 게임의 결과를 계산한다.
        // TODO : 결과에 따라 순차적으로 0.95 또는 1.95를 곱하고, 도중에 한 번이라도 지면 바로 0을 반환한다.
        // TODO : 사용자의 reward에 결과를 누적한다.
    }

    function playMulti(bytes[] calldata _data) external {
        for (uint256 i = 0; i < _data.length; ++i) {
            (uint256 gameId, uint256 amount, bytes memory data) = abi.decode(_data[i], (uint256, uint256, bytes));
            play(gameId, amount, data);
        }
    }

    function playRandom(uint256 _gameId, uint256 _amount, uint256 _length) external {
        playRandom(_gameId, _amount, _length, 0);
    }

    /* --- Public Functions --- */

    function playRandom(uint256 _gameId, uint256 _amount, uint256 _length, bytes32 _seed) public {
        GameMeta storage meta = games[_gameId];
        authorizePlay(meta, _amount);
        bytes memory data = abi.encodeWithSelector(IGame.playRandom.selector, _amount, _length);
        if (_seed != 0) {
            data = bytes.concat(data, abi.encode(_seed));
        }
        (bool res,) = meta.logic.delegatecall(data);
        require(res);
    }

    function play(uint256 _gameId, uint256 _amount, bytes memory _data) public {
        GameMeta storage meta = games[_gameId];
        authorizePlay(meta, _amount);
        (bool res,) = meta.logic.delegatecall(abi.encodeWithSelector(IGame.play.selector, _amount, _data));
        require(res);
    }

    /* --- Internal Functions --- */

    function createGameMeta(uint256 _id, address _logic, uint256 _version, uint256 _minAmount, uint256 _maxAmount)
        internal
        pure
        returns (GameMeta memory)
    {
        return GameMeta(_id, _logic, _version, _minAmount, _maxAmount);
    }

    function authorizePlay(GameMeta storage meta, uint256 _amount) internal {
        require(meta.minAmount <= _amount && _amount <= meta.maxAmount, InvalidAmount());
        require(cookie.transferFrom(msg.sender, address(this), _amount), TransferFailed());
    }
}
