// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";
import {IStation} from "src/Interface.sol";
import {GameMeta, IGame} from "src/logic/Game.sol";

contract StationProxy is ERC1967Proxy {
    constructor(address _implementation) ERC1967Proxy(_implementation, "") {}
}

contract GameProxy {
    mapping(uint256 => GameMeta) internal games;

    function setGame(GameMeta calldata _meta) public {
        // only owner
        games[_meta.id] = _meta;
    }

    function play(uint256 _gameId, uint256 _amount, bytes memory _data) public {
        (bool res,) = games[_gameId].logic.delegatecall(abi.encodeWithSelector(IGame.play.selector, _amount, _data));
        require(res);
    }
}
