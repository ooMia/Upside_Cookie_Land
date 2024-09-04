# UpgradeableGameRPS
[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/6b987a7026979291381fc0fd715dacee96957cea/src/GameProxy.sol)

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

