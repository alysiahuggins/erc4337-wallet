// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12 <=0.8.20;

import {Test, console2, Vm} from "forge-std/Test.sol";
import {BatchedWallet} from "../src/BatchedWallet.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {UserOperation} from "account-abstraction/interfaces/UserOperation.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";



contract BatchedWalletTest is Test {
    BatchedWallet public bw;
    IEntryPoint entryPoint = IEntryPoint(address(10101));
    uint256 chainId = block.chainid;
    uint256 walletOwnerPrivateKey = uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
    address walletOwnerAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    function setUp() public {
        bw = new BatchedWallet(entryPoint);
    }

    


    
}
