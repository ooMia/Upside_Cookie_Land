# UpgradeableGameRPS

[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/19596b6815ecddf8aaab1844bf71a89e8b87f4a0/src/GameProxy.sol)

**Inherits:**
UUPSUpgradeable, OwnableUpgradeable, [GameRPS](/src/GameRPS.sol/contract.GameRPS.md)

## Functions

### initialize

```solidity
function initialize() public initializer;
```

### \_authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal override onlyOwner;
```
