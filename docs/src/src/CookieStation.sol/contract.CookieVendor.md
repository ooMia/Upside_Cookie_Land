# CookieVendor

[Git Source](https://github.com/ooMia/Upside_Cookie_Land/blob/19596b6815ecddf8aaab1844bf71a89e8b87f4a0/src/CookieStation.sol)

## State Variables

### cookie

```solidity
Cookie public cookie;
```

### CK

```solidity
mapping(address => uint256) internal CK;
```

## Functions

### constructor

```solidity
constructor();
```

### buyCookie

```solidity
function buyCookie(uint256 _amount) public payable;
```

### sellCookie

```solidity
function sellCookie(uint256 _amount) public;
```

### increaseCookie

```solidity
function increaseCookie(uint256 _amount) internal;
```

### decreaseCookie

```solidity
function decreaseCookie(uint256 _amount) internal;
```

### getCookiePrice

```solidity
function getCookiePrice() public pure returns (uint256);
```

### getCookieBalance

```solidity
function getCookieBalance() public view returns (uint256);
```

## Errors

### InsufficientFunds

```solidity
error InsufficientFunds();
```

### TransferFailed

```solidity
error TransferFailed();
```
