// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {GamePlayed} from "game/Game.sol";
import {RPS} from "game/RPS.sol";
import {IStation, Station} from "station/Station.sol";
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
        setRPS(100, 10000);
        startHoax(msg.sender);
    }

    function payableCallMustSucceed(uint256 _value, bytes memory _data) internal returns (bool res) {
        (res,) = address(station).call{value: _value}(_data);
        require(res);
    }

    /* --- Admin Actions --- */

    function setRPS(uint256 _min, uint256 _max) public {
        station.setGame(0, address(new RPS()), 1, _min, _max);
    }

    /* --- User Actions --- */

    /* --- Buy Cookie --- */

    function buyCookie_asIs(uint256 _amount) internal view {
        assertGe(msg.sender.balance, _amount * station.getCookiePrice());
    }

    function buyCookie_toBe(uint256 _amount, uint256 _balance) internal view {
        assertLt(msg.sender.balance, _balance);
        assertEq(cookie.balanceOf(msg.sender), _amount);
    }

    function buyCookie(uint256 _amount) internal {
        uint256 cost = _amount * station.getCookiePrice();
        payableCallMustSucceed(cost, abi.encodeWithSignature("buyCookie(uint256)", _amount));
    }

    /* --- Approve Cookie --- */

    function approveCookie_asIs(uint256 _amount) internal view {
        assertGe(cookie.balanceOf(msg.sender), _amount);
    }

    function approveCookie_toBe(uint256 _amount) internal view {
        assertEq(cookie.allowance(msg.sender, address(station)), _amount);
    }

    function approveCookie(uint256 _amount) internal {
        cookie.approve(address(station), _amount);
    }

    /* --- Play RPS --- */

    function playRPS_asIs(uint256 _amount) internal view {
        assertGe(cookie.balanceOf(msg.sender), _amount);
        assertGe(cookie.allowance(msg.sender, address(station)), _amount);
    }

    function playRPS_toBe(uint256 _amount, uint256 _cookieBalance) internal view {
        assertEq(cookie.balanceOf(msg.sender), _cookieBalance - _amount);
    }

    function playRPS(uint256 _amount, uint256 _id, uint256 _len) internal {
        vm.expectEmit(true, true, true, false, address(station));
        emit GamePlayed(address(msg.sender), block.number, "RPS");
        // playRandom(_gameId, _amount, _length, _seed)
        payableCallMustSucceed(
            _id, abi.encodeWithSignature("playRandom(uint256,uint256,uint256,bytes32)", _id, _amount, _len, 1)
        );
    }

    /* --- Claim --- */

    function claim() public {
        (bool res,) = address(station).call(abi.encodeWithSignature("claim()"));
        require(res);
    }

    function claim_asIs() internal view {
        assertEq(cookie.balanceOf(address(msg.sender)), 0);
    }

    function claim_toBe() internal view {
        // temporary disabled
        // assertGt(cookie.balanceOf(address(msg.sender)), 0, "No Prize");
    }

    /* --- Basic Oracle Actions --- */
    function setRandomSeed(bytes32 _seed) public {}

    /* --- Steps For Playing --- */

    /// forge-config: default.fuzz.runs = 1
    function test_step1_buyCookie(uint8 _number) public {
        uint256 amount = _number == 0 ? vm.randomUint(1, 255) : _number;
        uint256 _balance = msg.sender.balance;

        buyCookie_asIs(amount);
        buyCookie(amount);
        buyCookie_toBe(amount, _balance);
    }

    /// forge-config: default.fuzz.runs = 1
    function test_step2_approveCookie(uint8 _number) public {
        uint256 amount = _number == 0 ? vm.randomUint(1, 255) : _number;
        buyCookie(amount);

        approveCookie_asIs(amount);
        approveCookie(amount);
        approveCookie_toBe(amount);
    }

    /// forge-config: default.fuzz.runs = 1
    function test_step3_playRPS(uint8 _number) public {
        uint256 _id = 0;
        uint256 _min = station.getGameMeta(_id).minAmount;
        uint256 amount = _number < _min ? vm.randomUint(_min, 255) : _number;

        buyCookie(amount);
        approveCookie(amount);
        uint256 _balance = cookie.balanceOf(msg.sender);

        playRPS_asIs(amount);
        playRPS(amount, _id, 3);
        playRPS_toBe(amount, _balance);
    }

    /// forge-config: default.fuzz.runs = 1
    function test_step4_claim(uint8 _number) public {
        uint256 _id = 0;
        uint256 _min = station.getGameMeta(_id).minAmount;
        uint256 amount = _number < _min ? vm.randomUint(_min, 255) : _number;
        amount *= 77;

        uint256 future = vm.getBlockNumber() + 4;
        vm.roll(future);
        vm.setBlockhash(future, bytes32(vm.randomUint()));
        vm.roll(future - 4);

        buyCookie(amount);
        approveCookie(amount);
        // TODO mock으로 결과 강제하기
        // 현재는 낮은 확률로 실패함
        for (uint256 i = 0; i < 77; ++i) {
            playRPS(amount / 77, _id, 1);
        }

        claim_asIs();
        claim();
        claim_toBe();
    }
}
