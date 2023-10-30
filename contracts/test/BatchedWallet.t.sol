// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12 <=0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {BatchedWallet} from "../src/BatchedWallet.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";



contract BatchedWalletTest is Test {
    BatchedWallet public bw;
    IEntryPoint entryPoint = IEntryPoint(address(10101));

    function setUp() public {
        bw = new BatchedWallet(entryPoint);
    }
    
}
