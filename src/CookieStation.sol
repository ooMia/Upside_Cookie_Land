// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

contract Cookie is ERC20 {
    constructor() ERC20("Cookie", "CKE") {
        _mint(msg.sender, type(uint256).max);
    }
}

contract CookieVendor {
    Cookie public cookie;

    mapping(address => uint256) internal CK;

    constructor() {
        cookie = new Cookie();
    }

    error InsufficientFunds();
    error TransferFailed();

    function buyCookie(uint256 _amount) public payable {
        require(msg.value >= getCookiePrice() * _amount, "InsufficientFunds");
        increaseCookie(_amount);
        require(cookie.transfer(msg.sender, _amount), "TransferFailed");
    }

    function sellCookie(uint256 _amount) public {
        decreaseCookie(_amount);
        require(cookie.transferFrom(msg.sender, address(this), _amount), "TransferFailed");
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

    function getCookieBalance() public view returns (uint256) {
        return CK[msg.sender];
    }
}

contract CookieStation is CookieVendor, Ownable, Pausable, Multicall {
    constructor() payable Ownable(msg.sender) {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    enum Status {
        NEED_READY,
        NEED_GAME,
        SHOULD_WITHDRAW
    }

    modifier onlyStatus(Status _status) {
        if (_status == Status.NEED_READY) {
            require(cookie.balanceOf(msg.sender) > 0, "UserStatus: Buy Cookie");
        } else if (_status == Status.SHOULD_WITHDRAW) {
            require(rewards[msg.sender] == 0, "UserStatus: Withdraw Rewards First");
        } else if (_status == Status.NEED_GAME) {
            require(gameCount > 0, "UserStatus: Set Game");
        }
        _;
    }

    struct GameMeta {
        address logic;
        uint256 minAmount;
        uint256 maxAmount;
    }

    mapping(uint256 => GameMeta) internal games;
    uint256 gameCount;
    mapping(address => uint256) public rewards;

    function setGame(uint256 _gameId, address _game, uint256 _minAmount, uint256 _maxAmount) external onlyOwner {
        require(games[_gameId].logic == address(0), "Game Already Exists");
        require(_game != address(0), "Invalid Game Address");
        require(_minAmount > 0, "Invalid Min Amount");
        require(_maxAmount >= _minAmount, "Invalid Max Amount");

        games[_gameId] = GameMeta({logic: _game, minAmount: _minAmount, maxAmount: _maxAmount});
        ++gameCount;
    }

    function getGameMeta(uint256 _gameId) external view returns (GameMeta memory) {
        return games[_gameId];
    }

    function claim() external onlyStatus(Status.SHOULD_WITHDRAW) {
        uint256 prize;
        (bool res, bytes memory data) = games[0].logic.call(abi.encodeWithSignature("claimReward(address)", msg.sender));
        require(res, "Claim Failed");
        prize += abi.decode(data, (uint256));
        rewards[msg.sender] += prize;
    }

    function withdraw() public {
        uint256 amount = rewards[msg.sender];
        rewards[msg.sender] = 0;
        cookie.transfer(msg.sender, amount);
    }

    function playRandom(uint256 _gameId, uint256 _amount, uint256 _length, bytes32 _seed)
        external
        onlyStatus(Status.NEED_GAME)
    {
        charge(_amount);
        require(_length > 0, "Invalid Length");
        require(_length <= 32, "Invalid Length");
        require(_amount >= games[_gameId].minAmount, "min amount");
        require(_amount <= games[_gameId].maxAmount, "max Amount");

        if (_seed == bytes32(0)) {
            _seed = keccak256(abi.encode(msg.sender, msg.data, cookie.balanceOf(msg.sender)));
        }
        (bool res,) = games[_gameId].logic.call(
            abi.encodeWithSignature("play(address,uint256,bytes32,uint8)", msg.sender, _amount, _seed, uint8(_length))
        );
        require(res);
    }

    function charge(uint256 _amount) private onlyStatus(Status.NEED_READY) {
        require(_amount > 0, "charge: Invalid Amount");
        require(cookie.transferFrom(msg.sender, address(this), _amount), "TransferFailed");
    }
}
