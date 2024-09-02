// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract TransientLock {
    modifier NonReentrant(bytes32 key) {
        assembly {
            if tload(key) { revert(0, 0) }
            tstore(key, 1)
        }
        _;
        assembly {
            tstore(key, 0)
        }
    }

    bytes32 internal constant LOCK = keccak256("lock");
    bytes32 internal constant B_LOCK = keccak256("b");
}
