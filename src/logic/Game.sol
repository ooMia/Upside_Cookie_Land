// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IOracle} from "src/Interface.sol";

contract Game {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }
}
