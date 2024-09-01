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
}
