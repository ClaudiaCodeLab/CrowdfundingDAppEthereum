// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./Ownable.sol";

/// @title EternalStorage Contract
/// @dev Implements eternal storage functionality
/// @author Claudia J.H. 
contract EternalStorage is Ownable {
    address latestVersion;

    /// @notice Modifier to allow function calls only from the latest version of the contract
    modifier onlyLatestVersion() {
        require(msg.sender == latestVersion, "Caller is not the latest version");
        _;
    }

    /// @notice Updates the contract to the latest version
    /// @param _newVersion The address of the new contract version
    function upgradeVersion(address _newVersion) public onlyAuthorized {
        latestVersion = _newVersion;
    }

    mapping(bytes32 => uint) uIntStorage;

    /// @notice Retrieves the stored value for a given key
    /// @param _key The key of the stored value
    /// @return uint The value associated with the given key
    function getUint(bytes32 _key) external view returns (uint) {
        return uIntStorage[_key];
    }

    /// @notice Stores a value for a given key
    /// @param _key The key of the stored value
    /// @param _value The value to be stored
    function setUint(bytes32 _key, uint _value) external onlyLatestVersion {
        uIntStorage[_key] = _value;
    }

    /// @notice Deletes the value stored for a given key
    /// @param _key The key of the stored value
    function deleteUint(bytes32 _key) external onlyLatestVersion {
        delete uIntStorage[_key];
    }
}
