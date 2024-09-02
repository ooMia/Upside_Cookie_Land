    // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

interface IGame {
    /// @dev Play the game with the amount of coin
    /// @param _amount The amount of coin for the game. The more coin you play, the more reward you get.
    /// @param _data The data to play the game. Need to be implemented in the game logic.
    function play(uint256 _amount, bytes calldata _data) external;

    function playRandom(uint256 _amount, uint256 _length, bytes32 _seed) external;

    function claim() external returns (uint256);
}

abstract contract Game is IGame, UUPSUpgradeable, Ownable {
    constructor() Ownable(msg.sender) {}

    /// @dev Save data for claiming verified snapshots
    struct GameData {
        uint256 amount; // given by player
        uint256 minTimestamp; // given by station
        uint256 targetHashBlockNumber; // given by station
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}

event GamePlayed(address indexed player, uint256 blockNumber, string gameName);
