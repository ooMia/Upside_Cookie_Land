// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "../src/util/Oracle.sol";
import "forge-std/Test.sol";

contract OracleTest is Test {
    Oracle oracle;

    function setUp() public {
        oracle = new Oracle();
        vm.roll(255);
        vm.warp(255 * 12);
    }

    function rewindBlock(uint8 _number) internal {
        uint16 _positive = uint16(_number + 1);
        bytes32 _hash = keccak256(abi.encode(_positive));
        vm.setBlockhash(block.number - _positive, _hash);
        vm.prevrandao(_hash);
        vm.roll(block.number - _positive);
        vm.warp(block.timestamp - _positive * 12);
    }

    /* --- Random Hash --- */

    function testHashOnSameCondition() public view {
        // msg.sender, block.timestamp, blockhash(block.number)
        bytes32 hash1 = oracle.getRandomHash();
        bytes32 hash2 = oracle.getRandomHash();
        assertEq(hash1, hash2);
    }

    /// forge-config: default.fuzz.runs = 1
    function testHashOnDifferentMessenger() public {
        bytes32 hash1 = oracle.getRandomHash();
        vm.prank(address(0x1234));
        bytes32 hash2 = oracle.getRandomHash();
        assertNotEq(hash1, hash2);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFuzzHashOnBlockPassed(uint8 _number) public {
        bytes32 hash2 = oracle.getRandomHash();
        rewindBlock(_number);
        bytes32 hash1 = oracle.getRandomHash();
        assertNotEq(hash1, hash2);
    }

    /* --- Random Uint8 --- */

    /// forge-config: default.fuzz.runs = 1
    function testFuzzRandomUintLength32(bytes32 _hash) public view {
        assertEq(oracle.getRandomUint8(_hash).length, 32);
    }

    /// forge-config: default.fuzz.runs = 1
    /// forge-config: default.fuzz.show-logs = true
    function testFuzzGetRandomUint8(bytes32 _hash) public view returns (uint8[] memory) {
        // no verification needed
        return oracle.getRandomUint8(_hash);
    }
}
