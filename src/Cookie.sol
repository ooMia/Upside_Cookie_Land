// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Cookie is ERC20 {
    constructor(
        string memory name,
        string memory symbol
    ) ERC20("Cookie", "CKE") {}
}
