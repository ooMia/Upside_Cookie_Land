// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

// /// @title Oracle interface
// /// @dev 임시로 구현된 형태의 오라클 사용을 위한 인터페이스
// interface IOracle {
//     /// @dev set the random seed
//     // function setRandomSeed(bytes32) external;

//     /// @dev Get the random hash by msg.sender and its seed
//     function getRandomHash() external view returns (bytes32);
//     function getRandomHash(uint256) external view returns (bytes32);

//     /// @dev Get random numbers by given hash
//     function getRandomUint8(bytes32) external pure returns (uint8[] memory);
//     function getRandomUint8WithBlockNumber(uint256) external view returns (uint8[] memory);
// }

// /// @title Oracle contract
// /// @dev 사용자로부터 미래에 존재하는 임의의 블록 번호를 부여받고, 해당 블록의 해시값을 이용하여 랜덤 값을 생성하는 컨트랙트
// contract Oracle is IOracle {
//     // predictable random number
//     function getRandomHash() external view override returns (bytes32) {
//         return getRandomHash(block.number);
//     }

//     function getRandomHash(uint256 _blockNumber) public view override returns (bytes32) {
//         return keccak256(abi.encode(msg.sender, block.timestamp, blockhash(_blockNumber)));
//     }

//     // must return same value with the same input
//     // this is not an actual random number generator

//     function getRandomUint8(bytes32 _hash) public pure override returns (uint8[] memory) {
//         _hash = keccak256(abi.encode(_hash));
//         uint8[] memory res = new uint8[](32);
//         for (uint8 i = 0; i < 32; ++i) {
//             res[i] = uint8(uint256(_hash) >> (i * 8));
//         }
//         return res;
//     }

//     function getRandomUint8WithBlockNumber(uint256 _blockNumber) external view override returns (uint8[] memory) {
//         return getRandomUint8(getRandomHash(_blockNumber));
//     }
// }
