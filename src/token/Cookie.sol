// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Cookie is ERC20 {
    constructor() ERC20("Cookie", "CKE") {
        _mint(msg.sender, type(uint256).max);
    }
}

abstract contract CookieVendor {
    ERC20 public cookie;

    mapping(address => uint256) internal CK;

    constructor() {
        cookie = new Cookie();
    }

    /// @dev Check-Efect-Interaction
    function buyCookie(uint256 _amount) external payable {
        require(msg.value >= getCookiePrice() * _amount);
        increaseCookie(_amount);
        require(cookie.transfer(msg.sender, _amount));
    }

    /// @dev Check-Efect-Interaction
    function sellCookie(uint256 _amount) external {
        decreaseCookie(_amount);
        require(cookie.transferFrom(msg.sender, address(this), _amount));
        (bool res,) = msg.sender.call{value: getCookiePrice() * _amount}("");
        require(res);
    }

    function increaseCookie(uint256 _amount) internal {
        require(CK[msg.sender] <= type(uint256).max - _amount);
        CK[msg.sender] += _amount;
    }

    function decreaseCookie(uint256 _amount) internal {
        require(CK[msg.sender] >= _amount);
        CK[msg.sender] -= _amount;
    }

    function getCookiePrice() public pure returns (uint256) {
        return 100;
    }

    function getcookieBalance() public view returns (uint256) {
        return CK[msg.sender];
    }
}
