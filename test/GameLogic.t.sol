// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {GameRPS} from "src/GameRPS.sol";

contract HandCalculationUnitTest is GameRPS, Test {
    function test_rule() public pure {
        assert(rule(ROCK, ROCK) == 1);
        assert(rule(PAPER, PAPER) == 1);
        assert(rule(SCISSORS, SCISSORS) == 1);

        assert(rule(ROCK, PAPER) == 0);
        assert(rule(ROCK, SCISSORS) == 2);

        assert(rule(PAPER, SCISSORS) == 0);
        assert(rule(PAPER, ROCK) == 2);

        assert(rule(SCISSORS, ROCK) == 0);
        assert(rule(SCISSORS, PAPER) == 2);
    }

    bytes1[] internal __RRRR = [ROCK, ROCK, ROCK, ROCK];
    bytes1[] internal __PPPP = [PAPER, PAPER, PAPER, PAPER];
    bytes1[] internal __SSSS = [SCISSORS, SCISSORS, SCISSORS, SCISSORS];

    function test_handsToBytes32() public view {
        assertEq(handsToBytes32(__RRRR), bytes32(hex"00000000"));
        assertEq(handsToBytes32(__PPPP), bytes32(hex"01010101"));
        assertEq(handsToBytes32(__SSSS), bytes32(hex"02020202"));
    }

    bytes32 internal RRRR = handsToBytes32(__RRRR);
    bytes32 internal PPPP = handsToBytes32(__PPPP);
    bytes32 internal SSSS = handsToBytes32(__SSSS);

    function test_calcMultiplier() public view {
        assertEq(calcMultiplier(1, ROCK, SCISSORS), 2);
        assertEq(calcMultiplier(1, ROCK, ROCK), 1);
        assertEq(calcMultiplier(1, ROCK, PAPER), 0);

        assertEq(calcMultiplier(4, RRRR, RRRR), 1);
        assertEq(calcMultiplier(4, RRRR, PPPP), 0);
        assertEq(calcMultiplier(4, RRRR, SSSS), 16);
    }
}

contract ClaimTest is Test {
    address user;
    GameRPS rps;

    function setUp() public {
        user = tx.origin;
        rps = new GameRPS();
        vm.label(address(rps), "rps");
        vm.startPrank(user);
        for (uint256 i = 0; i < 10; i++) {
            vm.roll(300 + i);
            pushRPS();
        }
        assertEq(rps.getUserGameLength(user), 30);
    }

    function pushRPS() public {
        bytes1[] memory hand = new bytes1[](1);
        hand[0] = rps.ROCK();
        rps.play(msg.sender, 100, hand);

        hand[0] = rps.PAPER();
        rps.play(msg.sender, 100, hand);

        hand[0] = rps.SCISSORS();
        rps.play(msg.sender, 100, hand);
    }

    function test_blockHash() public view {
        uint256 _bn = vm.getBlockNumber();
        bytes32 NONE = bytes32(0);
        assertNotEq(blockhash(_bn - 2), NONE);
        assertNotEq(blockhash(_bn - 1), NONE);
        assertEq(blockhash(_bn - 257), NONE);
        assertEq(blockhash(_bn), NONE);
    }

    function test_claimReward() public {
        vm.roll(304 + 1);
        uint256 res = rps.claimReward(tx.origin);
        assertGt(res, 0);
    }
}
