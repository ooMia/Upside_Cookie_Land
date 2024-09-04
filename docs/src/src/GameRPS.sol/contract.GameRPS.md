# GameRPS

[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/19596b6815ecddf8aaab1844bf71a89e8b87f4a0/src/GameRPS.sol)

## State Variables

### ROCK

```solidity
bytes1 public constant ROCK = bytes1(uint8(Hand.Rock));
```

### PAPER

```solidity
bytes1 public constant PAPER = bytes1(uint8(Hand.Paper));
```

### SCISSORS

```solidity
bytes1 public constant SCISSORS = bytes1(uint8(Hand.Scissors));
```

### games

```solidity
mapping(address => RPSPlay[]) public games;
```

## Functions

### getUserGameLength

```solidity
function getUserGameLength(address _user) public view returns (uint256);
```

### play

```solidity
function play(address _player, uint256 _amount, bytes1[] memory _hands) public virtual;
```

### play

```solidity
function play(address _player, uint256 _amount, bytes32 _hands, uint8 _streak) public virtual;
```

### handsToBytes32

```solidity
function handsToBytes32(bytes1[] memory _hands) public pure returns (bytes32 result);
```

### toRPS

```solidity
function toRPS(uint256 _amount, bytes32 _hands, uint8 _streak) public view returns (RPSPlay memory result);
```

### calcMultiplier

```solidity
function calcMultiplier(uint8 _len, bytes32 _player, bytes32 _dealer) internal pure returns (uint256 multiplier);
```

### rule

```solidity
function rule(bytes1 _player, bytes1 _dealer) internal pure returns (uint8);
```

### verify

```solidity
function verify(RPSPlay memory data) internal view returns (uint8 code);
```

### getDealerHash

```solidity
function getDealerHash(RPSPlay memory data) public view returns (bytes32);
```

### claimReward

```solidity
function claimReward(address owner) public returns (uint256 prize);
```

## Events

### GamePlayed

```solidity
event GamePlayed(address indexed player, uint256 indexed countPlay, uint256 targetBlock, uint256 timestamp);
```

### Claimed

```solidity
event Claimed(address indexed player, uint256 reward);
```

## Structs

### RPSPlay

```solidity
struct RPSPlay {
    address player;
    uint256 timestamp;
    uint256 targetBlock;
    uint256 bet;
    bytes32 hands;
    uint8 streak;
}
```

## Enums

### Hand

```solidity
enum Hand {
    Rock,
    Paper,
    Scissors
}
```
