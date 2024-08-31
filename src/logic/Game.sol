// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IGame, IOracle} from "src/Interface.sol";
import {DoubleEndedQueue} from "@openzeppelin/contracts/utils/structs/DoubleEndedQueue.sol";

abstract contract Game {

    IOracle internal oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    /// @dev Save data for claiming verified snapshots
    struct GameData {
        uint256 amount; // given by player
        bytes32 seed; // given by station
        uint256 minBlockNumber; // given by station
    }
}

struct GameMeta {
    uint256 id;
    address logic;
    uint256 version;
    uint256 minAmount;
    uint256 maxAmount;
}

// interface IGame {
//     /// @dev Mint and deposit the coin for the amount of eth sent
//     /// @param _minimumAmount The minimum amount of coin to mint. Revert if the amount is less than this.
//     function mintDepositCoin(uint256 _minimumAmount) external payable;

//     /// @dev Play the game with the amount of coin
//     /// @param _amount The amount of coin for the game. The more coin you play, the more reward you get.
//     /// @param _data The data to play the game. Need to be implemented in the game logic.
//     function play(uint256 _amount, bytes calldata _data) external;
// }
