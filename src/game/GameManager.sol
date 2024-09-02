// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {IGame} from "game/Game.sol";

interface IGameManager {
    function setGame(GameMeta calldata _meta) external;

    function play(uint256 _gameId, uint256 _amount, bytes calldata _data) external;

    function claim() external returns (uint256);

    struct GameMeta {
        uint256 id;
        address logic;
        uint256 version;
        uint256 minAmount;
        uint256 maxAmount;
    }

    function getGameMeta(uint256 _id) external view returns (GameMeta calldata);
}

contract GameManager is IGameManager, Ownable {
    uint256 nGames;
    mapping(uint256 => GameMeta) public games;

    constructor() Ownable(msg.sender) {}

    function getGameMeta(uint256 _id) public view returns (GameMeta memory) {
        return games[_id];
    }

    function setGame(GameMeta calldata _meta) external onlyOwner {
        if (games[_meta.id].logic == address(0)) {
            ++nGames;
        }
        games[_meta.id] = _meta;
    }

    function play(uint256 _gameId, uint256 _amount, bytes memory _data) public {
        (bool res,) = games[_gameId].logic.delegatecall(abi.encodeWithSelector(IGame.play.selector, _amount, _data));
        require(res);
    }

    /// @dev Refactoring required
    function claim() external returns (uint256) {
        address game = games[0].logic;
        require(game != address(0), "GameManager: NoGame");
        (bool res, bytes memory reward) = game.delegatecall(abi.encodeWithSelector(IGame.claim.selector));
        require(res, "GameManager: ClaimFailed");
        return abi.decode(reward, (uint256));
    }
}
