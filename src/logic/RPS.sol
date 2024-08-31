// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Game} from "./Game.sol";
import {IOracle} from "src/Interface.sol";

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

contract RPS is Game {
    enum Hand {
        Rock,
        Paper,
        Scissors
    }

    constructor() Game() {}

    struct RPSData {
        Hand[] playerHand; // given by player
        GameData gameData;
    }

    RPSData[] public stack;

    function play(uint256 _amount, Hand[] calldata _hand) external {
        stack.push(RPSData(_hand, GameData(_amount, block.number, block.timestamp)));
    }
}
