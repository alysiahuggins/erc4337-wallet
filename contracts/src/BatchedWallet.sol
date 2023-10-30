// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {IEntryPoint} from "account-abstraction/interfaces/IEntryPoint.sol";

contract BatchedWallet is Initializable{
    address public owner;
    IEntryPoint private immutable _entryPoint;

    event BatchedWalletInitialized(IEntryPoint indexed entryPoint, address owners);


    constructor(IEntryPoint entryPoint){
        _entryPoint = entryPoint;
        _disableInitializers(); //prevent the this implementation from being used by locking it
    }

    function initialize(address walletOwner) public initializer {
        _initialize(walletOwner);
    }

    function _initialize(address walletOwner) internal virtual {
        owner = walletOwner;
        emit BatchedWalletInitialized(_entryPoint, owner);
    }

    /**
    execute a transaction directly from user or entry point
    TODO: restrict access to entry Contract and owner */
    function execute(address dest, uint256 value, bytes calldata func) external {
        _call(dest, value, func);
    }

    /**
    executes batch of transactions directly from user or entry point
    TODO: restrict access to entry Contract and owner */
    function executeBatch(address[] calldata dest, uint256[] calldata value, bytes[] calldata func) external {
        require(dest.length == func.length && (value.length == 0 || value.length == func.length), "wrong array lengths");
        if (value.length == 0) {
            for (uint256 i = 0; i < dest.length; i++) {
                _call(dest[i], 0, func[i]);
            }
        } else {
            for (uint256 i = 0; i < dest.length; i++) {
                _call(dest[i], value[i], func[i]);
            }
        }
    }

    /**
    * _call helps us make abritrary function calls through this smart contract
    */
    function _call(address target, uint256 value, bytes memory data) internal {
        (bool success, bytes memory result) = target.call{value : value}(data);
        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }
}