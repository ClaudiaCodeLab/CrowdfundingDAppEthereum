// SPDX-License-Identifier: MIT
pragma solidity ^0.5.3;

import "./EmergencyStop.sol";
import "./EternalStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

/// @title Crowdfunding Contract
/// @dev Manages individual crowdfunding campaigns
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

    event FundingReceived(address contributor, uint amount, uint currentTotal);
    event CreatorPaid(address recipient);

    modifier inState(State _state) {
        require(state == _state, "Invalid project state");
        _;
    }

    modifier isCreator() {
        require(msg.sender == creator, "Caller is not the project creator");
        _;
    }

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

    function contribute() external inState(State.FundRaising) payable stoppedInEmergency {
        require(msg.sender != creator, "Creator cannot contribute");
        contributions[msg.sender] = contributions[msg.sender].add(msg.value);
        currentBalance = currentBalance.add(msg.value);

        emit FundingReceived(msg.sender, msg.value, currentBalance);

        checkIfFundingCompleteOrExpired();
    }

    function checkIfFundingCompleteOrExpired() public {
        if (currentBalance >= amountGoal) {
            state = State.Successful;
            payOut();
        } else if (block.timestamp > raiseBy) {
            state = State.Expired;
        }
        completeAt = block.timestamp;
    }

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