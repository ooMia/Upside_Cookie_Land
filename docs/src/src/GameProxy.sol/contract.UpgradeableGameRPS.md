# UpgradeableGameRPS
[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/385a70082d3fde125789b3e251779c57c35f3a4e/src/GameProxy.sol)

**Inherits:**
UUPSUpgradeable, OwnableUpgradeable, [GameRPS](/src/GameRPS.sol/contract.GameRPS.md)


## Functions
### initialize


```solidity
function initialize() public initializer;
```

### _authorizeUpgrade


```solidity
function _authorizeUpgrade(address newImplementation) internal override onlyOwner;
```

