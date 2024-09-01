// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Cookie is ERC20 {
    constructor() ERC20("Cookie", "CKE") {
        _mint(msg.sender, type(uint256).max);
    }
}
