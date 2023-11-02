## Batched Wallet - A smart wallet that allows you to batch transactions using ERC4337

Batched Wallet consists of:

-  **BatchedWallet.sol** - creates a batchedwallet (ERC4337 Smart Account) per user
-  **BatchedWalletFactory.sol** - factory for generating smart accounts
-  **Index.ts** - script that allows you to perform gasless transactions on Polgon Mumbai Testnet such as erc20 token transfer and batch transfers

## Design Decisions
- Followed eth-infinitism's account abstraction implementation for the SmartAccount and SmartAccountFactory
- For interacting with the smart contracts, used Stackup's userop.js SDK as the code was significantly less than eth-infinitism's SDK
- Stackup's userop.js does not support executeBatch with values (however, it's supported if you follow zeroDev's implementation)
- used Stackup's Paymaster for expediency as a paymaster requires not only a smart contract but an endpoint to respond to requests
- used Stackup's EntryPoint smart contract

## Usage

### Running gasless batch transactions with your own smart wallet
#### Install
```bash
$ yarn install 
```

#### Populate Environment
To run the script, `index.ts`, go the folder, `walletScripts`
```bash
$ cd walletScripts
``` 
Create a file named, `.env`, copy the contents of `.env.example` and replace the fields with their values.

#### Run the script
```bash
$ ts-node index.ts
```

### Running smart contract tests using forge
#### Navigate to the contracts directory via terminal
Go to the contracts directory
```bash
$ cd contracts
``` 

Run the tests
```bash
$ forge test --summary
```

### Deploying your own wallet factory using the code
#### Navigate to the contracts directory via terminal
Go to the contracts directory
```bash
$ cd contracts
``` 

#### Populate Environment
Create a file named, `.env`, copy the contents of `.env.example` and replace the fields with their values.

#### Run the script to deploy the factory contract
```bash
$ ts-node index.ts
```

#### Run the script to deploy the test erc20 contract
```bash
$ source .env
$ forge script script/BatchedWalletFactory.s.sol --rpc-url $MUMBAI_RPC_URL --broadcast -vvv
```
