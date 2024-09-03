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

    function callMustSucceed(address _target, bytes memory _data) private returns (bytes memory data) {
        bool res;
        (res, data) = address(_target).call(_data);
        if (!res) {
            console.log("callMustSucceed failed with target: %s", _target);
            console.logBytes(data);
            revert();
        }
    }

    function test_upgrade() public {
        address prev_impl = proxy.implementation();
        console.log("old implementation address: %s", prev_impl);
        callMustSucceed(address(proxy), abi.encodeWithSignature("initialize()"));
        callMustSucceed(address(proxy), abi.encodeWithSignature("owner()"));

        UpgradeableGameRPS new_game = new UpgradeableGameRPS();

        callMustSucceed(
            address(proxy), abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(new_game), "")
        );

        console.log("new implementation address: %s", proxy.implementation());
        assertNotEq(prev_impl, proxy.implementation());
    }
}
