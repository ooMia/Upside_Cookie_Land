// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Game} from "./Game.sol";
import {IOracle} from "src/Interface.sol";

contract RPS is Game {
    constructor(address _oracle) Game(_oracle) {}

    enum Hand {
        Rock,
        Paper,
        Scissors
    }

    struct RPSData {
        Hand[] playerHand; // given by player
        GameData gameData;
    }

    RPSData[] public stack;

    function play(uint256 _amount, Hand[] calldata _hand) external {
        GameData memory gameData = GameData(_amount, oracle.getRandomHash(), block.number);
        stack.push(RPSData(_hand, gameData));
    }
}
