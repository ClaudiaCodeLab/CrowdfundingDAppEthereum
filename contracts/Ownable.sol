// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

/// @title Ownable Contract
/// @dev Provides ownership functionality
/// @author Claudia J.H. 
contract Ownable {
    address public owner;

    /// @notice Initializes the contract by setting the deployer as the owner
    constructor() public {
        owner = msg.sender;
    }

    /// @notice Modifier to restrict access to the contract owner
    modifier onlyAuthorized() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /// @notice Checks if the caller is the contract owner
    /// @return bool Returns true if the caller is the owner
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    /// @notice Allows the current owner to transfer ownership to a new address
    /// @param newOwner The new owner of the contract
    function transferOwnership(address newOwner) public onlyAuthorized {
        _transferOwnership(newOwner);
    }

    /// @notice Internal function that transfers ownership to a new address
    /// @param newOwner The new owner of the contract
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        owner = newOwner;
    }
}
