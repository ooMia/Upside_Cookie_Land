// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/// @dev Emergency stoppable
contract StationProxy is ERC1967Proxy, Pausable, Ownable {
    constructor(address _implementation) ERC1967Proxy(_implementation, "") Ownable(msg.sender) {}

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function implementation() external view returns (address) {
        return _implementation();
    }

    receive() external payable {
        _fallback();
    }
}
