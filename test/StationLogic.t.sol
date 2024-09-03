// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {Cookie, CookieStation, CookieVendor} from "src/CookieStation.sol";
import {GameProxy} from "src/GameProxy.sol";
import {UpgradeableGameRPS} from "src/GameProxy.sol";

contract StationTest is Test {
    CookieStation station;
    Cookie cookie;
    GameProxy proxy;
    address user = msg.sender;

    function setUp() public {
        UpgradeableGameRPS game = new UpgradeableGameRPS();
        proxy = new GameProxy(game);
        station = new CookieStation(); // have max uint256 cookie
        cookie = station.cookie();
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

    function buyCookie_asIs(uint256 _amount) internal {
        vm.deal(msg.sender, _amount * station.getCookiePrice());
        assertGe(user.balance, _amount * station.getCookiePrice(), "Insufficient Funds");
    }

    function buyCookie_toBe(uint256 _amount, uint256 _balance) internal view {
        assertLt(user.balance, _balance);
        assertEq(cookie.balanceOf(user), _amount, "Cookie Balance");
    }

    function buyCookie(uint256 _amount) internal {
        uint256 cost = _amount * station.getCookiePrice();
        payableCallMustSucceed(cost, abi.encodeWithSelector(station.buyCookie.selector, _amount));
    }

    /// forge-config: default.fuzz.runs = 1
    function test_step1_buyCookie(uint8 _number) public {
        uint256 amount = _number == 0 ? vm.randomUint(1, 255) : _number;
        uint256 prev_balance = user.balance;

        buyCookie_asIs(amount);
        buyCookie(amount);
        buyCookie_toBe(amount, prev_balance);
    }
    // /* --- Approve Cookie --- */

    // function approveCookie_asIs(uint256 _amount) internal view {
    //     assertGe(cookie.balanceOf(msg.sender), _amount);
    // }

    // function approveCookie_toBe(uint256 _amount) internal view {
    //     assertEq(cookie.allowance(msg.sender, address(station)), _amount);
    // }

    // function approveCookie(uint256 _amount) internal {
    //     cookie.approve(address(station), _amount);
    // }

    // /* --- Play RPS --- */

    // function playRPS_asIs(uint256 _amount) internal view {
    //     assertGe(cookie.balanceOf(msg.sender), _amount);
    //     assertGe(cookie.allowance(msg.sender, address(station)), _amount);
    // }

    // function playRPS_toBe(uint256 _amount, uint256 _cookieBalance) internal view {
    //     assertEq(cookie.balanceOf(msg.sender), _cookieBalance - _amount);
    // }

    // function playRPS(uint256 _amount, uint256 _id, uint256 _len) internal {
    //     // vm.expectEmit(true, true, true, true);
    //     // emit GamePlayed(address(station), _len, block.number, block.timestamp);

    //     // playRandom(_gameId, _amount, _length, _seed)
    //     // payableCallMustSucceed(
    //     //     _id, abi.encodeWithSignature("playRandom(uint256,uint256,uint256,bytes32)", _id, _amount, _len, 1)
    //     // );
    //     //     function playRandom(uint256 _gameId, uint256 _amount, uint256 _length, bytes32 _seed) external {
    //     station.playRandom(_id, _amount, _len, bytes32(0));
    // }

    // /* --- Claim --- */

    // function claim() public {
    //     vm.roll(200);
    //     station.claim();
    // }

    // function claim_asIs() internal {
    //     assertEq(cookie.balanceOf(address(msg.sender)), 0);
    //     assertNotEq(station.getGameMeta(0).logic, address(0));
    //     vm.roll(100);
    // }

    // function claim_toBe() internal view {
    //     assertGt(address(msg.sender).balance, 0, "No Prize");
    //     // assertGt(address(msg.sender).balance, 0, "No Prize");
    //     // assertGt(cookie.balanceOf(address(msg.sender)), 0, "No Prize");
    // }

    // /* --- Basic Oracle Actions --- */
    // function setRandomSeed(bytes32 _seed) public {}

    // /// forge-config: default.fuzz.runs = 1
    // function test_step2_approveCookie(uint8 _number) public {
    //     uint256 amount = _number == 0 ? vm.randomUint(1, 255) : _number;
    //     buyCookie(amount);

    //     approveCookie_asIs(amount);
    //     approveCookie(amount);
    //     approveCookie_toBe(amount);
    // }

    // /// forge-config: default.fuzz.runs = 1
    // function test_step3_playRPS(uint8 _number) public {
    //     uint256 _id = 0;
    //     uint256 _min = station.getGameMeta(_id).minAmount;
    //     uint256 amount = _number < _min ? vm.randomUint(_min, 255) : _number;

    //     buyCookie(amount);
    //     approveCookie(amount);
    //     uint256 _balance = cookie.balanceOf(msg.sender);

    //     playRPS_asIs(amount);
    //     playRPS(amount, _id, 3);
    //     playRPS_toBe(amount, _balance);
    // }

    // /// forge-config: default.fuzz.runs = 1
    // function test_step4_claim(uint8 _number) public {
    //     uint256 _id = 0;
    //     uint256 _min = station.getGameMeta(_id).minAmount;
    //     uint256 amount = _number < _min ? vm.randomUint(_min, 255) : _number;
    //     amount *= 10;

    //     buyCookie(amount);
    //     approveCookie(amount);
    //     for (uint256 i = 0; i < 10; ++i) {
    //         assertGt(cookie.balanceOf(address(tx.origin)), 0);
    //         // console.log(address(station).balance);
    //         uint256 prev = cookie.balanceOf(address(station));
    //         console.log(cookie.balanceOf(address(station)));
    //         uint256 next = cookie.balanceOf(address(station));
    //         assertGt(next, prev);
    //         // console.log(station.getGameMeta(0).logic);
    //         // console.log(cookie.balanceOf(address(msg.sender)));
    //         playRPS(amount / 10, _id, 1);
    //     }
    //     claim_asIs();
    //     claim();
    //     claim_toBe();
    // }

    // TODO playRandom setGame Fail Case
}
