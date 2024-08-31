// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "util/Oracle.sol";

contract OracleTest is Test {
    Oracle oracle;

    function setUp() public {
        oracle = new Oracle();
        vm.roll(255);
        vm.warp(255 * 12);
    }

    function rewindBlock(uint8 _number) internal {
        bytes32 _hash = keccak256(abi.encode(_number));
        uint256 _block = vm.getBlockNumber();
        vm.setBlockhash(_block - _number, _hash);
        vm.prevrandao(_hash);
        vm.roll(_block - _number);
        rewind(_number * 12);
    }

    /* --- Random Hash --- */

    function test_HashOnSameCondition() public view {
        // msg.sender, block.timestamp, blockhash(block.number)
        bytes32 hash1 = oracle.getRandomHash();
        bytes32 hash2 = oracle.getRandomHash();
        assertEq(hash1, hash2);
    }

    function test_HashOnMessengerChanged() public {
        bytes32 hash1 = oracle.getRandomHash();
        vm.prank(vm.randomAddress());
        bytes32 hash2 = oracle.getRandomHash();
        assertNotEq(hash1, hash2);
    }

    function test_HashOnBlockChanged() public {
        bytes32 hash2 = oracle.getRandomHash();
        rewindBlock(1);
        bytes32 hash1 = oracle.getRandomHash();
        assertNotEq(hash1, hash2);
    }

    /* --- Random Uint8 --- */

    /// forge-config: default.fuzz.runs = 1
    function testFuzz_RandomUintLength32(bytes32 _hash) public view {
        assertEq(oracle.getRandomUint8(_hash).length, 32);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFuzz_GetRandomUint8(bytes32 _hash) public view returns (uint8[] memory) {
        // no verification needed
        return oracle.getRandomUint8(_hash);
    }
}
