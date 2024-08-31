// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "forge-std/mocks/MockERC20.sol";

import {RPS} from "logic/RPS.sol";
import {Station} from "logic/Station.sol";
import {Oracle} from "util/Oracle.sol";
import {GameProxy, StationProxy} from "util/Proxy.sol";

contract StationTest is Test {
    StationProxy station;
    GameProxy game;
    MockERC20 mock = new MockERC20();

    function setUp() public {
        mock.initialize("Cookie", "CK", 18);
        Station _station = new Station(new Oracle(), IERC20(address(mock)));
        station = new StationProxy(address(_station));
        game = new GameProxy();
    }
}
