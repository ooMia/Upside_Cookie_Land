// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Game, GamePlayed} from "game/Game.sol";
import {IOracle} from "util/Oracle.sol";

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

    /* --- External Functions --- */

    function play(uint256 _amount, bytes calldata _data) external override {
        play(_amount, abi.decode(_data, (Hand[])));
    }

    function playRandom(uint256 _amount, uint256 _length, bytes32 _seed) external {
        _length = _length == 0 ? 1 : _length % 32;
        if (_seed == 0) {
            play(_amount, generateRandomHand(_length));
        } else {
            play(_amount, generateRandomHand(_length, _seed));
        }
    }

    /* --- Internal Functions --- */

    /// @dev Highly recommend to use transient storage
    function play(uint256 _amount, Hand[] memory _hand) internal {
        require(_amount > 0 && _hand.length > 0);
        // use transient: TSTORE and TLOAD
        // https://soliditylang.org/blog/2024/01/26/transient-storage/
        stack.push(RPSData(_hand, GameData(_amount, block.number + 4, block.timestamp)));
        emit GamePlayed(msg.sender, block.number, "RPS");
    }

    function generateRandomHand(uint256 _length, bytes32 _seed) internal pure returns (Hand[] memory hand) {
        hand = new Hand[](_length);
        bytes32 _hash = keccak256(abi.encode(_seed));
        for (uint8 i = 0; i < _length; ++i) {
            hand[i] = Hand(uint8(uint256(_hash) >> (i * 8)) % 3);
        }
    }

    function generateRandomHand(uint256 _length) internal view returns (Hand[] memory) {
        return generateRandomHand(_length, keccak256(abi.encode(stack.length, tx.origin)));
    }
}
