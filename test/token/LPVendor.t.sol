// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

// import "forge-std/Test.sol";

// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import {LPVendor} from "token/LP.sol";

// contract LPVendorTest is Test {
//     address vendor = address(new LPVendor());
//     IERC20 cookie = LPVendor(vendor).cookie();

//     function setUp() external {
//         startHoax(msg.sender);
//     }

//     function test_DepositLP() public {
//         uint256 amount = 100;
//         station.depositLP(amount);
//         assertEq(station.getLPBalance(), amount);
//     }

//     function test_WithdrawLP() public {
//         uint256 amount = 100;
//         station.depositLP(amount);
//         station.withdrawLP(amount);
//         assertEq(station.getLPBalance(), 0);
//     }
// }
