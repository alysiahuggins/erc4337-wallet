// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12 <=0.8.20;

import {Test, console2, Vm} from "forge-std/Test.sol";
import {BatchedWallet} from "../src/BatchedWallet.sol";
import {BatchedWalletFactory} from "../src/BatchedWalletFactory.sol";

import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";
import {UserOperation} from "account-abstraction/interfaces/UserOperation.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";



contract BatchedWalletTest is Test {
    BatchedWallet public bw;
    IEntryPoint entryPoint = IEntryPoint(address(10101));
    uint256 chainId = block.chainid;
    uint256 walletOwnerPrivateKey = uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
    address walletOwnerAddress = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address alice = makeAddr('alice');
    uint salt = 12345;

    function setUp() public {
        BatchedWalletFactory bwFactory = new BatchedWalletFactory(entryPoint);

        vm.startPrank(alice);
        bw = bwFactory.createAccount(alice, salt);
        vm.deal(address(bw), 1 ether);
        vm.stopPrank();

    }

    function testOwner() public{
        assertEq(bw.owner(), alice);
    }
    
    function testExecute() public {
        address alice = makeAddr('alice');
        address bob = makeAddr('bob');

        vm.startPrank(alice);
        bw.execute(bob, 0.001 ether, "");
        assertEq(bob.balance, 0.001 ether);
        assertEq(address(bw).balance, 0.999 ether);
        vm.stopPrank();
    }

    
}
