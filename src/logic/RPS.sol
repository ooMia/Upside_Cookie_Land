// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Game, GamePlayed} from "src/logic/Game.sol";
import {IOracle} from "src/util/Oracle.sol";

// /**
//  * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
//  * {upgradeToAndCall}.
//  *
//  * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
//  *
//  * ```solidity
//  * function _authorizeUpgrade(address) internal onlyOwner {}
//  * ```
//  */
// function _authorizeUpgrade(address newImplementation) internal virtual;

enum Hand {
    Rock,
    Paper,
    Scissors
}

struct RPSData {
    Hand[] playerHand; // given by player
    Game.GameData gameData;
}

contract RPS is Game {
    RPSData[] internal stack;

    function play(uint256 _amount, Hand[] memory _hand) internal {
        stack.push(RPSData(_hand, GameData(_amount, block.number, block.timestamp)));
        emit GamePlayed(msg.sender, _amount, abi.encode(_hand));
    }

    function play(uint256 _amount, bytes memory _data) external override {
        play(_amount, abi.decode(_data, (Hand[])));
    }
}
