// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {RPS} from "src/logic/RPS.sol";

contract RPSMock is RPS {
    function setStack(RPSData[] calldata _stack) external {
        stack = _stack;
    }
}
