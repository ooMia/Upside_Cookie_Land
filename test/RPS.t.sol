// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {RPS} from "src/logic/RPS.sol";

// 프록시를 통해 정상적으로 호출 가능한지 확인

contract RPSProxy {
    RPS public rps;

    constructor(RPS _rps) {
        rps = _rps;
    }

    function play(uint256 _amount, RPS.Hand[] calldata _hand) external {
        rps.play(_amount, _hand);
    }
}

