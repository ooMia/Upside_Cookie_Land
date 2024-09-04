# GameProxy

[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/19596b6815ecddf8aaab1844bf71a89e8b87f4a0/src/GameProxy.sol)

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
