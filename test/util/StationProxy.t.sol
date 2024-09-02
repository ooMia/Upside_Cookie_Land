// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {GameProxy} from "game/GameProxy.sol";
import {RPS} from "game/RPS.sol";
import {Station} from "station/Station.sol";
import {IOracle, Oracle} from "util/Oracle.sol";

// contract StationTest is Test {
//     StationProxy station;
//     GameProxy game;
//     IERC20 cookie = new ERC20Mock();

//     function setUp() public {
//         IOracle oracle = new Oracle();
//         Station _station = new Station(oracle, cookie);
//         station = new StationProxy(address(_station));
//         game = new GameProxy();
//     }
// }
