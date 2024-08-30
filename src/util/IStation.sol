// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

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
