// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./Ownable.sol";

/// @title EmergencyStop Contract
/// @dev Implements emergency stop functionality
/// @author Claudia J.H.
contract EmergencyStop is Ownable {
    bool public isStopped = false;

    /// @notice Modifier to allow function calls only when the contract is not stopped
    modifier stoppedInEmergency {
        require(!isStopped, "Contract is stopped due to an emergency");
        _;
    }

    /// @notice Modifier to allow function calls only when the contract is stopped
    modifier onlyWhenStopped {
        require(isStopped, "Contract is not stopped");
        _;
    }

    /// @notice Allows the owner to stop the contract during an emergency
    function stopContract() public onlyAuthorized {
        isStopped = true;
    }

    /// @notice Allows the owner to resume the contract after it has been stopped
    function resumeContract() public onlyAuthorized onlyWhenStopped {
        isStopped = false;
    }
}
