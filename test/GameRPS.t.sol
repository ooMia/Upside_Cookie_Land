// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {DoubleEndedQueue} from "@openzeppelin/contracts/utils/structs/DoubleEndedQueue.sol";

import "forge-std/Test.sol";

contract GameRPS {
    enum Hand {
        Rock,
        Paper,
        Scissors
    }

    bytes1 constant ROCK = bytes1(uint8(Hand.Rock));
    bytes1 constant PAPER = bytes1(uint8(Hand.Paper));
    bytes1 constant SCISSORS = bytes1(uint8(Hand.Scissors));
    bytes1 constant RRRR = bytes1(abi.encodePacked(ROCK, ROCK, ROCK, ROCK));
    bytes1 constant PPPP = bytes1(abi.encodePacked(PAPER, PAPER, PAPER, PAPER));
    bytes1 constant SSSS = bytes1(abi.encodePacked(SCISSORS, SCISSORS, SCISSORS, SCISSORS));


    event GamePlayed(address indexed player, uint256 indexed gameId, uint256 targetBlock, uint256 timestamp);

    struct RPSPlay {
        address player;
        uint256 timestamp;
        uint256 targetBlock;
        uint256 bet;
        bytes32 hands;
    }

    mapping(address => RPSPlay[]) public games;

    // function claimReward() public {
    //     RPSPlay[] storage myGame = games[msg.sender];
    //     uint256 maxBlock = block.number - 1;
    //     uint256 minBlock = block.number - 256;
    //     uint256 reward = 0;
    //     uint256 idx = 0;
    //     payable(msg.sender).transfer(reward);
    // }

    function calculateMultiplier(uint8 _len, bytes32 _player, bytes32 _dealer)
        public
        pure
        returns (uint256 multiplier)
    {
        require(_len > 0, "GameRPS: calculateMultiplier: _len > 0");
        _len %= 32;
        multiplier = 1;
        for (uint8 i = 0; i < _len; ++i) {
            bytes1 playerHand = _player[i];
            bytes1 dealerHand = _dealer[i];
            multiplier *= rule(playerHand, dealerHand);
            if (multiplier == 0) {
                break;
            }
        }
    }

    function rule(bytes1 _player, bytes1 _dealer) internal pure returns (uint8) {
        if (_player == _dealer) {
            return 1;
        } else if (_player == ROCK && _dealer == SCISSORS) {
            return 2;
        } else if (_player == PAPER && _dealer == ROCK) {
            return 2;
        } else if (_player == SCISSORS && _dealer == PAPER) {
            return 2;
        } else {
            return 0;
        }
    }
}

contract TestGameRPS is GameRPS, Test {
    function test_rule() public pure {
        assert (rule(ROCK, ROCK) == 1);
        assert (rule(PAPER, PAPER) == 1);
        assert (rule(SCISSORS, SCISSORS) == 1);

        assert (rule(ROCK, PAPER) == 0);
        assert (rule(ROCK, SCISSORS) == 2);

        assert (rule(PAPER, SCISSORS) == 0);
        assert (rule(PAPER, ROCK) == 2);

        assert (rule(SCISSORS, ROCK) == 0);
        assert (rule(SCISSORS, PAPER) == 2);
    }

    function test_claimReward() public {}

    function test_calculateMultiplier() public pure {
        assert (calculateMultiplier(1, ROCK, ROCK) == 1);
        assert (calculateMultiplier(1, ROCK, PAPER) == 0);
        assert (calculateMultiplier(1, ROCK, SCISSORS) == 2);

        assert (calculateMultiplier(4, RRRR, RRRR) == 1);
        assert (calculateMultiplier(4, RRRR, PPPP) == 0);
        assert (calculateMultiplier(4, RRRR, SSSS) == 16);
    }
}
