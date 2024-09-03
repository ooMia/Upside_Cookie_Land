// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {Cookie, CookieStation, CookieVendor} from "src/CookieStation.sol";
import {GameProxy, UpgradeableGameRPS} from "src/GameProxy.sol";
import {GameRPS} from "src/GameRPS.sol";

contract StationTest is Test {
    CookieStation station;
    Cookie cookie;
    GameProxy proxy;
    address user;

    function setUp() public {
        UpgradeableGameRPS game = new UpgradeableGameRPS();
        proxy = new GameProxy(game);
        station = new CookieStation(); // have max uint256 cookie
        cookie = station.cookie();

        user = payable(address(0x123));
        vm.startPrank(user);
    }

    /* --- Helper Functions --- */

    function setRPS(uint256 _min, uint256 _max) public {
        station.setGame(0, address(proxy), _min, _max);
    }

    function payableCallMustSucceed(uint256 _value, bytes memory _data) internal returns (bool res) {
        (res,) = address(station).call{value: _value}(_data);
        require(res);
    }

    /* --- Steps For Playing --- */

    /* --- Buy Cookie --- */

    function buyCookie(uint256 _amount) public {
        uint256 cost = _amount * station.getCookiePrice();
        uint256 prev_balance = user.balance;

        assertGe(prev_balance, cost, "Insufficient Funds");
        payableCallMustSucceed(cost, abi.encodeWithSelector(station.buyCookie.selector, _amount));

        assertLe(user.balance, prev_balance);
        assertEq(cookie.balanceOf(user), _amount, "Cookie Balance");
    }

    function test_step1_buyCookie() public {
        uint256 amount = 100;
        uint256 cost = amount * station.getCookiePrice();
        vm.deal(user, cost);
        buyCookie(amount);
    }

    /* --- Approve Cookie --- */

    function approveCookie(uint256 _amount) internal {
        assertGe(cookie.balanceOf(user), _amount);
        cookie.approve(address(station), _amount);
        assertEq(cookie.allowance(user, address(station)), _amount);
    }

    function test_step2_approveCookie() public {
        uint256 amount = 100;
        uint256 cost = amount * station.getCookiePrice();
        vm.deal(user, cost);
        buyCookie(amount);
        approveCookie(amount);
    }

    /* --- Play RPS --- */

    function playRPS(uint256 _id, uint256 _amount, uint256 _len) internal {
        uint256 _cookieBalance = cookie.balanceOf(user);
        assertGe(_cookieBalance, _amount);
        assertGe(cookie.allowance(user, address(station)), _amount);

        // vm.expectEmit(true, false, false, true, address(msg.sender ));
        // //   event GamePlayed(address indexed player, uint256 indexed countPlay, uint256 targetBlock, uint256 timestamp);
        // emit GameRPS.GamePlayed(address(user), 0, block.number, block.timestamp);

        station.playRandom(_id, _amount, _len, bytes32(0));

        assertEq(cookie.balanceOf(user), _cookieBalance - _amount);
    }

    function test_step3_playRPS() public {
        uint256 id = 0;
        uint256 amount = 100;
        uint256 cost = amount * station.getCookiePrice();
        vm.deal(user, cost);
        setRPS(100, 200);

        buyCookie(amount);
        approveCookie(amount);

        playRPS(id, amount, 1);
    }

    /* --- Claim --- */

    function test_step4_claim() public {
        uint256 id = 0;
        uint256 iter = 10;
        uint256 amount = 100 * iter;
        uint256 cost = amount * station.getCookiePrice();
        vm.deal(user, cost);

        buyCookie(amount);
        approveCookie(amount);

        vm.roll(300);
        setRPS(100, 200);

        for (uint256 i = 0; i < iter; ++i) {
            playRPS(id, amount / iter, 1);
        }
        vm.roll(306);

        // assertEq(msg.sender, user);
        station.claim();

        assertGt(cookie.balanceOf(address(user)), 0, "No Prize");
    }

    // TODO playRandom setGame Fail Case
}
