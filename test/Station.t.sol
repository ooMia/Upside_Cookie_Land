// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20} from "forge-std/mocks/MockERC20.sol";

import {IStation, Station} from "logic/Station.sol";
import {IOracle, Oracle} from "util/Oracle.sol";

contract StationTest is Test {
    Station station;
    MockERC20 mock = new MockERC20();
    IERC20 cookie;

    function setUp() public {
        IOracle oracle = new Oracle();
        mock.initialize("Cookie", "CK", 18);
        cookie = IERC20(address(mock));
        station = new Station(oracle, cookie);
        hoax(msg.sender);
    }

    function test_ReadyForPlaying(uint16 _number) public {
        (bool res,) = address(station).call{value: 1 ether}(abi.encode(Station.buyCookie.selector, _number));
        assertTrue(res);
        assertEq(cookie.balanceOf(address(msg.sender)), _number);
    }
}
