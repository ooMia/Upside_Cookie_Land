// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IStation, Station} from "logic/Station.sol";
import {Cookie, CookieVendor} from "token/Cookie.sol";
import {IOracle, Oracle} from "util/Oracle.sol";
import {GameProxy, IGameProxy} from "util/Proxy.sol";

contract StationTest is Test {
    Station station;
    IERC20 cookie;
    IOracle oracle;

    function setUp() external {
        GameProxy game = new GameProxy();
        station = new Station(address(game));
        cookie = station.cookie();
        oracle = station.oracle();
        startHoax(msg.sender);
    }

    function payableCallMustSucceed(uint256 _value, bytes memory _data) internal returns (bool res) {
        (res,) = address(station).call{value: _value}(_data);
        require(res);
    }

    function getCookieBalances(address _user) internal view returns (uint256 ucb, uint256 scb) {
        (ucb, scb) = (cookie.balanceOf(_user), cookie.balanceOf(address(station)));
    }

    /* --- Buy Cookie --- */

    function buyCookie(uint256 _pay, uint256 _amount) internal {
        payableCallMustSucceed(_pay, abi.encodeWithSelector(CookieVendor.buyCookie.selector, _amount));
        assertEq(_amount, station.getcookieBalance());
        assertEq(_amount, cookie.balanceOf(msg.sender));
    }

    /// forge-config: default.fuzz.runs = 1
    function test_buyCookie(uint8 _number) external {
        uint256 amount = uint16(_number) + 1;
        uint256 cost = amount * station.getCookiePrice();
        buyCookie(cost, amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_buyCookie_InsufficientEtherSent(uint8 _number) external {
        uint256 amount = uint16(_number) + 1;
        uint256 cost = amount * station.getCookiePrice() - 1;
        buyCookie(cost, amount);
    }

    /* --- Sell Cookie --- */

    function sellCookie(uint256 _amount) internal {
        uint256 ueb = msg.sender.balance;
        (uint256 ucb1, uint256 scb1) = getCookieBalances(msg.sender);
        cookie.approve(address(station), _amount);
        station.sellCookie(_amount);
        (uint256 ucb2, uint256 scb2) = getCookieBalances(msg.sender);
        assertEq(ucb1, _amount);
        assertEq(ucb2, 0);
        assertEq(scb2, scb1 + _amount);
        assertEq(msg.sender.balance, ueb + _amount * station.getCookiePrice());
    }

    /// forge-config: default.fuzz.runs = 1
    function test_sellCookie(uint8 _number) external {
        uint256 amount = uint16(_number) + 1;
        buyCookie(amount * station.getCookiePrice(), amount);
        sellCookie(amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_sellCookie_InsufficientCookie(uint8 _number) external {
        uint256 amount = uint16(_number) + 1;
        buyCookie(amount * station.getCookiePrice(), amount);
        sellCookie(amount + 1);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_sellCookie_InsufficientAllowance(uint8 _number) external {
        uint256 amount = uint16(_number) + 1;
        buyCookie(amount * station.getCookiePrice(), amount);
        station.sellCookie(amount);
    }
}
