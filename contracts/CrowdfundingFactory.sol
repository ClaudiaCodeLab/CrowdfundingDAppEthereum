// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./EmergencyStop.sol";
import "./EternalStorage.sol";
import "./Crowdfunding.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title CrowdfundingFactory Contract
/// @dev Manages the creation and management of crowdfunding projects
/// @author Claudia J.H. 
contract CrowdfundingFactory is EmergencyStop, EternalStorage {
    using SafeMath for uint;

    Crowdfunding[] private projects;
    address payable _powner;

    /// @notice Emitted when a new crowdfunding project is started
    /// @param contractAddress The address of the new crowdfunding contract
    /// @param projectStarter The address of the project creator
    /// @param projectTitle The title of the project
    /// @param deadline The deadline for the project
    /// @param goalAmount The funding goal for the project
    event ProjectStarted(
        address contractAddress,
        address projectStarter,
        string projectTitle,
        uint deadline,
        uint goalAmount
    );

    /// @notice Initializes the factory contract and sets the owner
    constructor() public payable {
        _powner = msg.sender;
    }

    /// @notice Creates a new crowdfunding project
    /// @param title The title of the crowdfunding project
    /// @param durationInDays The duration of the fundraising campaign in days
    /// @param amountToRaise The funding goal for the project (in Ether)
    function startProject(
        string calldata title,
        uint durationInDays,
        uint amountToRaise
    ) external payable stoppedInEmergency {
        require(msg.value == 0.001 ether, "Fee to create a project is 0.001 ether");
        _powner.transfer(msg.value);

        uint raiseUntil = block.timestamp.add(durationInDays.mul(1 days));
        uint amountInWei = amountToRaise.mul(1 ether);

        Crowdfunding newProject = new Crowdfunding(msg.sender, title, raiseUntil, amountInWei);
        newProject.transferOwnership(owner);
        projects.push(newProject);

        emit ProjectStarted(
            address(newProject),
            msg.sender,
            title,
            raiseUntil,
            amountToRaise
        );
    }

    /// @notice Returns all active crowdfunding projects
    /// @return Crowdfunding[] Array of all crowdfunding projects created
    function returnAllProjects() external view returns (Crowdfunding[] memory) {
        return projects;
    }
}
