// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IOracle} from "src/Interface.sol";

/// @title Oracle contract
/// @dev 사용자로부터 미래에 존재하는 임의의 블록 번호를 부여받고, 해당 블록의 해시값을 이용하여 랜덤 값을 생성하는 컨트랙트
contract Oracle is IOracle {
    // predictable random number
    function getRandomHash() external view override returns (bytes32) {
        return keccak256(abi.encode(msg.sender, block.timestamp, blockhash(block.number)));
    }

    // must return same value with the same input
    // this is not an actual random number generator
    function getRandomUint8(bytes32 _hash) external pure override returns (uint8[] memory) {
        uint8[] memory res = new uint8[](32);
        for (uint8 i = 0; i < 32; ++i) {
            res[i] = uint8(uint256(_hash) >> (i * 8));
        }
        return res;
    }
}
