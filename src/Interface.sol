// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

/// @title Oracle interface
/// @dev 임시로 구현된 형태의 오라클 사용을 위한 인터페이스
interface IOracle {
    /// @dev set the random seed
    // function setRandomSeed(bytes32) external;

    /// @dev Get the random hash by msg.sender and its seed
    function getRandomHash() external view returns (bytes32);

    /// @dev Get random numbers by given hash
    function getRandomUint8(bytes32) external pure returns (uint8[] memory);
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

    /// @dev Mint and deposit the coin for the amount of eth sent
    /// @param _minimumAmount The minimum amount of coin to mint. Revert if the amount is less than this.
    function mintDepositCoin(uint256 _minimumAmount) external payable;
}

interface IGame {
    /// @dev Play the game with the amount of coin
    /// @param _amount The amount of coin for the game. The more coin you play, the more reward you get.
    /// @param _data The data to play the game. Need to be implemented in the game logic.
    function play(uint256 _amount, bytes calldata _data) external;
}