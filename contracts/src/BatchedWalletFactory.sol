// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12 <=0.8.20;

import "./BatchedWallet.sol";

contract BatchedWalletFactory{
    BatchedWallet public immutable batchedWalletImplementation;

    constructor(IEntryPoint entryPoint) {
        batchedWalletImplementation = new BatchedWallet(entryPoint);
    }
}