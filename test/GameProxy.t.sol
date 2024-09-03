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

        game.transferOwnership(address(this));
        console.log("game.owner: %s", game.owner());
        console.log("caller: %s", address(this));
    }

    function test_upgrade() public {
        console.log("old implementation address: %s", proxy.implementation());
        UpgradeableGameRPS new_game = new UpgradeableGameRPS();
        assertNotEq(address(new_game), address(game));
        new_game.transferOwnership(address(this));
        console.log("new_game.owner: %s", new_game.owner());
        console.log("caller: %s", address(this));

        (bool res,) = address(proxy).call(
            abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(new_game), "")
        );
        require(res, "upgrade failed");
        console.log("new implementation address: %s", proxy.implementation());
    }

    // function test_play() public {
    //     bytes1[] memory hands = [game.ROCK, game.PAPER, game.SCISSORS];
    //     proxy.play(100, hands);
    //     assertEq(game.getUserGameLength(address(this)), 1);
    // }
}
