// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

/// @title Oracle interface
/// @dev 임시로 구현된 형태의 오라클 사용을 위한 인터페이스
interface IOracle {
    /// @dev set the random seed
    function setRandomSeed(bytes32) external;

    /// @dev Get the random hash by msg.sender and its seed
    function getRandomHash() external view returns (bytes32);

    /// @dev Get the random numbers by msg.sender and its seed
    function getRandomNumbers(bytes32) external view returns (uint256[] memory);
}

interface IStation {
    struct User {
        Coin coin;
        LP lp;
    }

    struct Coin {
        uint256 amount;
    }

    struct LP {
        uint256 locked;
    }

    function buyCoin(uint256 _amount) external;

    function sellCoin(uint256 _amount) external;

    function depositLP(uint256 _amount) external;

    function withdrawLP(uint256 _amount) external;
}

interface IGame {
    function play(uint256 _amount) external;
}
