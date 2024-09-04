# GameProxy
[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/6b987a7026979291381fc0fd715dacee96957cea/src/GameProxy.sol)

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

