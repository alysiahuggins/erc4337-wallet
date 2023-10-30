// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

contract BatchedWallet{

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