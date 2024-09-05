// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./EmergencyStop.sol";
import "./EternalStorage.sol";
import "./Crowdfunding.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title CrowdfundingFactory Contract
/// @dev Handles the creation and management of crowdfunding projects
contract CrowdfundingFactory is EmergencyStop, EternalStorage {
    using SafeMath for uint;

    Crowdfunding[] private projects;
    address payable _powner;

    event ProjectStarted(
        address contractAddress,
        address projectStarter,
        string projectTitle,
        uint deadline,
        uint goalAmount
    );

    constructor() public payable {
        _powner = msg.sender;
    }

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

    function returnAllProjects() external view returns (Crowdfunding[] memory) {
        return projects;
    }
}