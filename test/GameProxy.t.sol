// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {GameProxy, UpgradeableGameRPS} from "src/GameProxy.sol";

contract GameProxyUnitTest is Test {
    GameProxy proxy;
    UpgradeableGameRPS game;

    function setUp() public {
        game = new UpgradeableGameRPS();
        proxy = new GameProxy(game);
    }

    function test_upgrade() public {
        bool res;
        bytes memory data;

        address admin = vm.randomAddress();
        vm.startPrank(admin);

        (res, data) = address(proxy).call(abi.encodeWithSignature("initialize()"));
        require(res);
        (res, data) = address(proxy).call(abi.encodeWithSignature("owner()"));
        require(res);

        address _owner = abi.decode(data, (address));

        console.log("owner: %s", _owner);
        console.log(proxy.implementation());
        // game.transferOwnership(address(proxy));

        console.log("old implementation address: %s", proxy.implementation());
        UpgradeableGameRPS new_game = new UpgradeableGameRPS();
        console.log("new_game.owner: %s", new_game.owner());
        console.log("caller: %s", address(this));

        (res, data) =
            address(proxy).call(abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(new_game), ""));
        require(res, "upgrade failed");
        console.log("new implementation address: %s", proxy.implementation());
    }

    // function test_play() public {
    //     bytes1[] memory hands = [game.ROCK, game.PAPER, game.SCISSORS];
    //     proxy.play(100, hands);
    //     assertEq(game.getUserGameLength(address(this)), 1);
    // }
}
