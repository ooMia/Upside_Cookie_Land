// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Script.sol";

import {CookieStation} from "src/CookieStation.sol";
import {GameProxy, UpgradeableGameRPS} from "src/GameProxy.sol";

/// @dev forge script -f $RPC Deploy
contract Deploy is Script {
    uint256 constant stationBalance = 1 ether;
    uint256 secret;
    address admin;
    GameProxy proxy;
    CookieStation station;

    function setUp() public {
        secret = vm.envUint("PRIVATE_KEY"); // .env: PRIVATE_KEY=0x1234...
        admin = vm.rememberKey(secret);
        require(admin.balance >= stationBalance, "Insufficient balance");
        require(secret != 0 && admin != address(0), "Check .env");
    }

    function run() public {
        vm.startBroadcast(secret);

        // Deploy GameRPS
        UpgradeableGameRPS game = new UpgradeableGameRPS();
        game.initialize();
        require(game.owner() == admin, "Check #1");

        // Deploy GameProxy
        proxy = new GameProxy(game);
        require(proxy.implementation() == address(game), "Check #2");

        // Deploy CookieStation
        station = new CookieStation{value: stationBalance}();
        require(station.owner() == admin, "Check #3");
        require(address(station).balance == stationBalance, "Check #4");

        // Set RPS game
        station.setGame(0, address(proxy), 100, 200);

        require(station.getGameMeta(0).logic == address(proxy), "Check #5");

        vm.stopBroadcast();
    }
}
