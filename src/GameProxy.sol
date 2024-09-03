// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {GameRPS} from "src/GameRPS.sol";

contract UpgradeableGameRPS is UUPSUpgradeable, OwnableUpgradeable, GameRPS {
    function initialize() initializer public {
        __Ownable_init(msg.sender);
    }
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function play(uint256 _amount, bytes1[] memory _hands) public override onlyProxy {
        super.play(_amount, _hands);
    }

    function play(uint256 _amount, bytes32 _hands, uint8 _streak) public override onlyProxy {
        super.play(_amount, _hands, _streak);
    }
}

contract GameProxy is ERC1967Proxy {
    constructor(UUPSUpgradeable _impl) ERC1967Proxy(address(_impl), "") {}

    function implementation() public view returns (address) {
        return _implementation();
    }

    receive() external payable {
        _fallback();
    }
}
