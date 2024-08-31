// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IGame, IOracle, IStation} from "src/Interface.sol";

/// @dev 반드시 admin 계정을 통해서만 오라클을 설정하고 실행해야 함
contract Station {
    IOracle public oracle;

    constructor(address _oracle) {
        oracle = IOracle(_oracle);
    }

    function buyCoin(uint256 _amount) external {
        // TODO : implement
    }

    function sellCoin(uint256 _amount) external {
        // TODO : implement
    }

    function depositLP(uint256 _amount) external {
        // TODO : implement
    }

    function withdrawLP(uint256 _amount) external {
        // TODO : implement
    }

    function gotRandomNumbers(bytes32 _hash) external {
        // TODO: 내부 게임에 전파하고, 개별 claim 처리
    }
}
