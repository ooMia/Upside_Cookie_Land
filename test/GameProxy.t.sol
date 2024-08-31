// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

import {GameMeta, GamePlayed} from "logic/Game.sol";
import {Hand, RPS} from "logic/RPS.sol";
import {GameProxy} from "util/Proxy.sol";

contract RPSProxyTest is Test {
    RPS rps;
    GameProxy gameProxy;
    Hand[] hands;

    function setUp() public {
        rps = new RPS();
        gameProxy = new GameProxy();
        gameProxy.setGame(GameMeta(0, address(rps), 0, 100, 1000));
        hands.push(Hand.Rock);
        hands.push(Hand.Paper);
        hands.push(Hand.Scissors);
    }

    function testPlay() public {
        vm.expectEmit(true, true, true, false, address(rps));
        emit GamePlayed(address(this), 100, abi.encode(hands));
        rps.play(100, abi.encode(hands));
    }

    function testCallPlayViaProxy() public {
        vm.expectEmit(true, true, true, false, address(gameProxy));
        emit GamePlayed(address(this), 100, abi.encode(hands));
        (bool res,) =
            address(gameProxy).call(abi.encodeWithSelector(GameProxy.play.selector, 0, 100, abi.encode(hands)));
        assertTrue(res);
    }
}
