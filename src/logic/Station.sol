// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IOracle, IStation} from "src/Interface.sol";
import {GameMeta, IGame} from "src/logic/Game.sol";

/// @dev 반드시 admin 계정을 통해서만 오라클을 설정하고 실행해야 함
contract Station {
    // stoppable
    IOracle public oracle;

    mapping(uint256 => GameMeta) public games;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function buyCoin(uint256 _amount) external {
        // TODO : implement
    }

    function sellCoin(uint256 _amount) external {
        // TODO : implement
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
