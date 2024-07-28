# Utility Contracts

A collection of simple Solidity contracts for various practical use cases. Get started easily with `npm i`.

Some helpful commands:

```shell
npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/<CONTRACT>.ts --network <NETWORK>
```

# Contract Directory

### `MockToken.sol`

A very basic ERC20 token implementation. Easy to deploy for testing & used in many other implementations.

### `ERC20Escrow.sol`

A simple escrow contract implementation that requires the counterparties, ERC20 token addresses, and amounts known ahead of time. 
