# GameProxy
[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/385a70082d3fde125789b3e251779c57c35f3a4e/src/GameProxy.sol)

**Inherits:**
ERC1967Proxy


## Functions
### constructor


```solidity
constructor(UUPSUpgradeable _impl) ERC1967Proxy(address(_impl), "");
```

### implementation


```solidity
function implementation() public view returns (address);
```

### receive


```solidity
receive() external payable;
```

