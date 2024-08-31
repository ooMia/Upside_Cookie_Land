// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {DoubleEndedQueue} from "@openzeppelin/contracts/utils/structs/DoubleEndedQueue.sol";
import {IGame, IOracle} from "src/Interface.sol";

abstract contract Game is UUPSUpgradeable, Ownable {
    constructor() Ownable(tx.origin) {}

    /// @dev Save data for claiming verified snapshots
    struct GameData {
        uint256 amount; // given by player
        uint256 minBlockNumber; // given by station
        uint256 minTimestamp; // given by station
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override onlyOwner {}
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
