// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IOracle} from "src/Interface.sol";

/// @title Oracle contract
/// @dev 사용자로부터 미래에 존재하는 임의의 블록 번호를 부여받고, 해당 블록의 해시값을 이용하여 랜덤 값을 생성하는 컨트랙트
contract Oracle is IOracle {
    bytes32 private randomSeed;
    uint256 nonce;

    modifier statusChange() {
        ++nonce;
        _;
    }

    function setRandomSeed(bytes32 _randomSeed) external override {
        randomSeed = _randomSeed;
    }

    function getRandomHash() external view override returns (bytes32) {
        return keccak256(abi.encodePacked(msg.sender, randomSeed));
    }

    function getRandomNumbers(bytes32 _hash) external view override returns (uint256[] memory) {
        // block.difficulty block.prevrandao
    }
}
