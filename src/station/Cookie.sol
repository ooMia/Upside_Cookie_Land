// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.26;

// import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// contract Cookie is ERC20 {
//     constructor() ERC20("Cookie", "CKE") {
//         _mint(msg.sender, type(uint256).max);
//     }
// }

// contract CookieVendor {
//     ERC20 public cookie;

//     mapping(address => uint256) internal CK;

//     constructor() {
//         cookie = new Cookie();
//     }

//     error InsufficientFunds();
//     error TransferFailed();

//     /// @dev Check-Efect-Interaction
//     function buyCookie(uint256 _amount) public payable {
//         require(msg.value >= getCookiePrice() * _amount, InsufficientFunds());
//         increaseCookie(_amount);
//         require(cookie.transfer(msg.sender, _amount), TransferFailed());
//     }

//     /// @dev Check-Efect-Interaction
//     function sellCookie(uint256 _amount) public {
//         decreaseCookie(_amount);
//         require(cookie.transferFrom(msg.sender, address(this), _amount), TransferFailed());
//         (bool res,) = msg.sender.call{value: getCookiePrice() * _amount}("");
//         require(res);
//     }

//     function increaseCookie(uint256 _amount) internal {
//         require(CK[msg.sender] <= type(uint256).max - _amount);
//         CK[msg.sender] += _amount;
//     }

//     function decreaseCookie(uint256 _amount) internal {
//         require(CK[msg.sender] >= _amount);
//         CK[msg.sender] -= _amount;
//     }

//     function getCookiePrice() public pure returns (uint256) {
//         return 100;
//     }

//     function getCookieBalance() public view returns (uint256) {
//         return CK[msg.sender];
//     }
// }
