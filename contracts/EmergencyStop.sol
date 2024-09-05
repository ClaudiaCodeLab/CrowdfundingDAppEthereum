// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./Ownable.sol";

/// @title EmergencyStop Contract
/// @dev Implements emergency stop functionality
contract EmergencyStop is Ownable {
    bool public isStopped = false;

    modifier stoppedInEmergency {
        require(!isStopped, "Contract is stopped due to an emergency");
        _;
    }

    modifier onlyWhenStopped {
        require(isStopped, "Contract is not stopped");
        _;
    }

    function stopContract() public onlyAuthorized {
        isStopped = true;
    }

    function resumeContract() public onlyAuthorized onlyWhenStopped {
        isStopped = false;
    }
}