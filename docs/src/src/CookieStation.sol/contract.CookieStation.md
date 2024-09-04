# CookieStation

[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/19596b6815ecddf8aaab1844bf71a89e8b87f4a0/src/CookieStation.sol)

**Inherits:**
[CookieVendor](/src/CookieStation.sol/contract.CookieVendor.md), Ownable, Pausable, Multicall

## State Variables

### games

```solidity
mapping(uint256 => GameMeta) internal games;
```

### gameCount

```solidity
uint256 gameCount;
```

### rewards

```solidity
mapping(address => uint256) public rewards;
```

## Functions

### constructor

```solidity
constructor() Ownable(msg.sender);
```

### pause

```solidity
function pause() public onlyOwner;
```

### unpause

```solidity
function unpause() public onlyOwner;
```

### onlyStatus

```solidity
modifier onlyStatus(Status _status);
```

### setGame

```solidity
function setGame(uint256 _gameId, address _game, uint256 _minAmount, uint256 _maxAmount) external onlyOwner;
```

### getGameMeta

```solidity
function getGameMeta(uint256 _gameId) external view returns (GameMeta memory);
```

### claim

```solidity
function claim() external onlyStatus(Status.SHOULD_WITHDRAW);
```

### withdraw

```solidity
function withdraw() public;
```

### playRandom

```solidity
function playRandom(uint256 _gameId, uint256 _amount, uint256 _length, bytes32 _seed)
    external
    onlyStatus(Status.NEED_GAME);
```

### charge

```solidity
function charge(uint256 _amount) private onlyStatus(Status.NEED_READY);
```

## Structs

### GameMeta

```solidity
struct GameMeta {
    address logic;
    uint256 minAmount;
    uint256 maxAmount;
}
```

## Enums

### Status

```solidity
enum Status {
    NEED_READY,
    NEED_GAME,
    SHOULD_WITHDRAW
}
```
