// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./Ownable.sol";

/// @title EternalStorage Contract
/// @dev Implements eternal storage functionality
contract EternalStorage is Ownable {
    address latestVersion;

    modifier onlyLatestVersion() {
        require(msg.sender == latestVersion, "Caller is not the latest version");
        _;
    }

    function upgradeVersion(address _newVersion) public onlyAuthorized {
        latestVersion = _newVersion;
    }

    mapping(bytes32 => uint) uIntStorage;

    function getUint(bytes32 _key) external view returns (uint) {
        return uIntStorage[_key];
    }

    function setUint(bytes32 _key, uint _value) external onlyLatestVersion {
        uIntStorage[_key] = _value;
    }

    function deleteUint(bytes32 _key) external onlyLatestVersion {
        delete uIntStorage[_key];
    }
}