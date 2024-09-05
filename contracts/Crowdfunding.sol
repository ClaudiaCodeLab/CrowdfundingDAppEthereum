// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./EmergencyStop.sol";
import "./EternalStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title Crowdfunding Contract
/// @dev Manages individual crowdfunding campaigns
/// @author Claudia J.H. 
contract Crowdfunding is EmergencyStop, EternalStorage, ReentrancyGuard {
    using SafeMath for uint256;

    enum State { FundRaising, Expired, Successful }

    address payable public creator;
    uint public amountGoal;
    uint public completeAt;
    uint public currentBalance;
    uint public raiseBy;
    string public title;
    State public state = State.FundRaising;

    mapping(address => uint) public contributions;

    /// @notice Emitted when a contribution is received
    /// @param contributor The address of the contributor
    /// @param amount The amount contributed
    /// @param currentTotal The current total amount of funds raised
    event FundingReceived(address contributor, uint amount, uint currentTotal);

    /// @notice Emitted when the project creator is paid
    /// @param recipient The address of the project creator
    event CreatorPaid(address recipient);

    /// @notice Modifier to ensure the function is called only in a specific project state
    /// @param _state The required state for the function to execute
    modifier inState(State _state) {
        require(state == _state, "Invalid project state");
        _;
    }

    /// @notice Modifier to ensure only the project creator can call the function
    modifier isCreator() {
        require(msg.sender == creator, "Caller is not the project creator");
        _;
    }

    /// @notice Initializes the crowdfunding contract with the given parameters
    /// @param projectStarter The address of the project creator
    /// @param projectTitle The title of the crowdfunding project
    /// @param fundRaisingDeadline The deadline for the fundraising (in Unix time)
    /// @param goalAmount The funding goal for the project (in Wei)
    constructor(
        address payable projectStarter,
        string memory projectTitle,
        uint fundRaisingDeadline,
        uint goalAmount
    ) public {
        creator = projectStarter;
        title = projectTitle;
        raiseBy = fundRaisingDeadline;
        amountGoal = goalAmount;
        currentBalance = 0;
    }

    /// @notice Allows users to contribute to the crowdfunding project
    function contribute() external inState(State.FundRaising) payable stoppedInEmergency {
        require(msg.sender != creator, "Creator cannot contribute");
        contributions[msg.sender] = contributions[msg.sender].add(msg.value);
        currentBalance = currentBalance.add(msg.value);

        emit FundingReceived(msg.sender, msg.value, currentBalance);

        checkIfFundingCompleteOrExpired();
    }

    /// @notice Checks if the funding goal is reached or if the project has expired
    function checkIfFundingCompleteOrExpired() public {
        if (currentBalance >= amountGoal) {
            state = State.Successful;
            payOut();
        } else if (block.timestamp > raiseBy) {
            state = State.Expired;
        }
        completeAt = block.timestamp;
    }

    /// @notice Pays out the raised funds to the project creator if the goal is met
    /// @return bool Returns true if the payout was successful
    function payOut() internal inState(State.Successful) nonReentrant returns (bool) {
        uint totalRaised = currentBalance;
        currentBalance = 0;

        if (creator.send(totalRaised)) {
            emit CreatorPaid(creator);
            return true;
        } else {
            currentBalance = totalRaised;
            state = State.Successful;
        }
        return false;
    }

    /// @notice Allows contributors to get a refund if the project expired without meeting the goal
    /// @return bool Returns true if the refund was successful
    function getRefund() public inState(State.Expired) nonReentrant returns (bool) {
        require(contributions[msg.sender] != 0, "No contributions to refund");

        uint amountToRefund = contributions[msg.sender];
        contributions[msg.sender] = 0;

        if (!msg.sender.send(amountToRefund)) {
            contributions[msg.sender] = amountToRefund;
            return false;
        } else {
            currentBalance = currentBalance.sub(amountToRefund);
        }
        return true;
    }
}
