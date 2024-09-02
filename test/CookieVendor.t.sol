// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Cookie, CookieVendor} from "station/Cookie.sol";

contract CookieVendorTest is Test {
    address vendor = address(new CookieVendor());
    IERC20 cookie = CookieVendor(vendor).cookie();

    function setUp() external {
        startHoax(msg.sender);
    }

    /// @dev global util function
    function payableCallMustSucceed(uint256 _value, bytes memory _data) internal returns (bool res) {
        (res,) = address(vendor).call{value: _value}(_data);
        require(res);
    }

    function getCookieBalances(address _user) internal view returns (uint256 ucb, uint256 vcb) {
        (ucb, vcb) = (cookie.balanceOf(_user), cookie.balanceOf(vendor));
    }

    /* --- Buy Cookie --- */

    function _buyCookie(uint256 _pay, uint256 _amount) internal {
        payableCallMustSucceed(_pay, abi.encodeWithSelector(CookieVendor.buyCookie.selector, _amount));
        assertEq(_amount, CookieVendor(vendor).getCookieBalance());
        assertEq(_amount, cookie.balanceOf(msg.sender));
    }

    /// forge-config: default.fuzz.runs = 1
    function test_buyCookie(uint8 _number) external {
        uint256 amount = _number / 2 + 1;
        uint256 cost = amount * getPrice();
        _buyCookie(cost, amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_buyCookie_InsufficientEtherSent(uint8 _number) external {
        uint256 amount = _number / 2 + 1;
        uint256 cost = amount * getPrice() - 1;
        _buyCookie(cost, amount);
    }

    /* --- Sell Cookie --- */

    function _sellCookie(uint256 _amount) internal {
        uint256 ueb = msg.sender.balance;
        (uint256 ucb1, uint256 scb1) = getCookieBalances(msg.sender);
        cookie.approve(vendor, _amount);
        CookieVendor(vendor).sellCookie(_amount);
        (uint256 ucb2, uint256 scb2) = getCookieBalances(msg.sender);
        assertEq(ucb1, _amount);
        assertEq(ucb2, 0);
        assertEq(scb2, scb1 + _amount);
        assertEq(msg.sender.balance, ueb + _amount * getPrice());
    }

    /// forge-config: default.fuzz.runs = 1
    function test_sellCookie(uint8 _number) external {
        uint256 amount = _number / 2 + 1;
        _buyCookie(amount * getPrice(), amount);
        _sellCookie(amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_sellCookie_InsufficientCookie(uint8 _number) external {
        uint256 amount = _number / 2 + 1;
        _buyCookie(amount * getPrice(), amount);
        _sellCookie(amount + 1);
    }

    /// forge-config: default.fuzz.runs = 1
    function testFail_sellCookie_InsufficientAllowance(uint8 _number) external {
        uint256 amount = _number / 2 + 1;
        _buyCookie(amount * getPrice(), amount);
        CookieVendor(vendor).sellCookie(amount);
    }

    function getPrice() internal view returns (uint256) {
        return CookieVendor(vendor).getCookiePrice();
    }
}
