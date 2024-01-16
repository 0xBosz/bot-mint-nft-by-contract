// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Node_Caller {
    fallback() external payable {
        assembly {
            calldatacopy(0x0, 0x0, calldatasize())
            // This address is Host_Minter.sol address
            let success := delegatecall(gas(), 0xB25f1f0B4653b4e104f7Fbd64Ff183e23CdBa582, 0x0, calldatasize(), 0x0, 0)
            if iszero(success) {
                revert(0x0, returndatasize())
            }
        }
    }
}
