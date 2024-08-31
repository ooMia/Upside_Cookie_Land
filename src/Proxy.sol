// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IStation} from "./Interface.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract StationProxy is ERC1967Proxy {
    constructor(address _implementation, bytes memory _data) ERC1967Proxy(_implementation, _data) {}
}

contract GameProxy {
    // 등록된 게임 id의 컨트랙트에 대한 delegatecall 호출
    receive() external payable {}
}
