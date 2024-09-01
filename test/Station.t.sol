// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IStation, Station} from "logic/Station.sol";
import {Cookie} from "token/Cookie.sol";
import {IOracle, Oracle} from "util/Oracle.sol";
import {GameProxy, IGameProxy} from "util/Proxy.sol";

contract StationTest is Test {
    Station station;
    IERC20 cookie;
    IOracle oracle;

    function setUp() public {
        GameProxy game = new GameProxy();
        station = new Station(address(game));
        cookie = station.cookie();
        oracle = station.oracle();
    }

    function payableCallMustSucceed(uint256 _value, bytes memory _data) internal returns (bool res) {
        (res,) = address(station).call{value: _value}(_data);
        require(res);
    }

    /* --- Buy Cookie --- */

    function buyCookie(uint256 _pay, uint256 _amount) internal {
        payableCallMustSucceed(_pay, abi.encodeWithSelector(Station.buyCookie.selector, _amount));
        assertEq(_amount, station.getcookieBalance(), "cookie balance");
        assertEq(_amount, cookie.balanceOf(msg.sender), "user balance");
    }

    /// forge-config: default.fuzz.runs = 1
    function test_ReadyForPlaying(uint8 _number) public {
        startHoax(msg.sender);
        uint256 amount = uint16(_number) + 1;
        uint256 cost = amount * station.getCookiePrice();
        buyCookie(cost, amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_InsufficientEtherSent(uint8 _number) public {
        startHoax(msg.sender);
        uint256 amount = uint16(_number) + 1;
        uint256 cost = amount * station.getCookiePrice() - 1;
        buyCookie(cost, amount);
    }
}
