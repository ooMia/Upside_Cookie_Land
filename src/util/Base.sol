// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;


import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


interface ILogic {
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
}

abstract contract Logic is ILogic, Ownable {
    mapping(address => User) internal users;

    /// @dev got ETH and increase ERC20 token allowance
    function buyCoin(uint256 _amount) external virtual;

    /// @dev decrease ERC20 token allowance and send ETH
    function sellCoin(uint256 _amount) external virtual;

    /// @dev increase total LP and increase ERC20 token allowance
    function depositLP(uint256 _amount) external virtual;

    function withdrawLP(uint256 _amount) external virtual;
}
// TODO 코드 패턴: State Machine

// TODO 코드 패턴: Proxy Pattern

// TODO 코드 패턴: Multicall Pattern

// TODO 코드 패턴: Checks Effects Interactions

// TODO 코드 패턴: [Pull over Push](https://fravoll.github.io/solidity-patterns/pull_over_push.html)

// TODO 코드 패턴: Emergency Stop

// TODO 도전 과제 #1: 추가 패턴 [secure_ether_transfer](https://fravoll.github.io/solidity-patterns/secure_ether_transfer.html)

// TODO 도전 과제 #1: 추가 패턴 [solidity-patterns]https://fravoll.github.io/solidity-patterns/)

// TODO 도전 과제 #2. 토크노믹스

// TODO 도전 과제 #3: 취약점

// TODO 도전과제 #4: 성능/가스 최적화


// TODO Ownable 패턴
// TODO Pausable 패턴
// TODO Pull Payment 패턴
// TODO Circuit Breaker 패턴
// TODO State Machine 패턴
// TODO Oracle 패턴
// TODO Proxy 패턴
// TODO Library 패턴
// TODO Factory 패턴