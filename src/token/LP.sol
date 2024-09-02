// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

contract LPVendor {
    mapping(address => uint256) internal LP;

    function getLPBalance() external view returns (uint256) {
        return LP[msg.sender];
    }

    function depositLP(uint256 _amount) external {
        // TODO : implement
    }

    function withdrawLP(uint256 _amount) external {
        // TODO : implement
    }
}
