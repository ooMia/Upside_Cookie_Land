// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Cookie, CookieVendor} from "token/Cookie.sol";

import {GameMeta, IGame} from "logic/Game.sol";
import {IOracle, Oracle} from "util/Oracle.sol";
import {IGameProxy} from "util/Proxy.sol";

interface IStation {
    function buyCookie(uint256 _amount) external payable;

    function sellCookie(uint256 _amount) external;

    function depositLP(uint256 _amount) external;

    function withdrawLP(uint256 _amount) external;

    /// @dev Mint and deposit the coin for the amount of eth sent
    /// @param _minimumAmount The minimum amount of coin to mint. Revert if the amount is less than this.
    function mintDepositCookie(uint256 _minimumAmount) external payable;

    function playMulti(bytes[] calldata _data) external;
}

/// @dev 반드시 admin 계정을 통해서만 오라클을 설정하고 실행해야 함
contract Station is CookieVendor, Ownable {
    // stoppable
    IOracle public oracle;
    address internal gameProxy;

    struct User {
        uint256 CK;
        uint256 LP;
    }

    mapping(uint256 => GameMeta) internal games;
    mapping(address => User) internal users;

    // only for initial setup
    constructor(address _game) Ownable(msg.sender) {
        oracle = new Oracle();
        gameProxy = _game;
        require(cookie.balanceOf(address(this)) == type(uint256).max);
    }

    function mintDepositCookie(uint256 _minimumAmount) external payable {
        // TODO : implement
    }

    function getLPBalance() external view returns (uint256) {
        return users[msg.sender].LP;
    }

    function depositLP(uint256 _amount) external {
        // TODO : implement
    }

    function withdrawLP(uint256 _amount) external {
        // TODO : implement
    }

    function gotRandomNumbers(bytes32 _hash) external {
        // TODO: 내부 게임에 전파하고, 개별 claim 처리
    }

    function setGame(GameMeta calldata _meta) external {
        // only admin
        games[_meta.id] = _meta;
    }

    function playMulti(bytes[] calldata _data) external {
        // TODO no reentrancy
        for (uint256 i = 0; i < _data.length; ++i) {
            (uint256 gameId, uint256 amount, bytes memory data) = abi.decode(_data[i], (uint256, uint256, bytes));
            play(gameId, amount, data);
        }
    }

    function play(uint256 _gameId, uint256 _amount, bytes memory _data) public {
        // TODO 주어진 양만큼의 코인이 있는지 확인
        // TODO 오라클을 통해 랜덤 시드를 받아옴
        // TODO 주어진 data에 대한 play 수행

        GameMeta storage meta = games[_gameId];
        (bool res,) = meta.logic.delegatecall(abi.encodeWithSelector(IGame.play.selector, _amount, _data));
        require(res);
    }
}
