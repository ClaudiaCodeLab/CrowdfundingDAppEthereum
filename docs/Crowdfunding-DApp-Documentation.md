# Crowdfunding DApp Documentation

## Introduction

This document outlines the smart contract architecture and deployment details for a decentralized crowdfunding platform on the Ethereum blockchain. The platform allows project creators to launch campaigns, receive contributions in Ether, and manage refunds if fundraising goals are not met.

## Contracts Overview

The DApp consists of the following smart contracts:
- **Ownable**: Handles ownership of contracts, allowing only the owner to execute critical functions.
- **EmergencyStop**: Provides emergency functionality to stop or resume contracts during critical events.
- **EternalStorage**: Manages the data persistence layer to ensure campaigns' data isn't lost during contract upgrades.
- **CrowdfundingFactory**: Allows the creation and management of crowdfunding campaigns, handles the fee collection, and keeps an index of active projects.
- **Crowdfunding**: Handles the contributions, tracks project states (Fundraising, Expired, Successful), and manages the payout or refund process based on the project outcome.

## Detailed Contracts Explanation

### Ownable Contract
- **Purpose**: Ensure that only the owner of the contract can execute specific functions.
- **Functions**:
  - `transferOwnership()`: Allows transferring the contract's ownership to a new address.
  - `isOwner()`: Returns true if the caller is the contract's owner.

### EmergencyStop Contract
- **Purpose**: Provides a way to stop critical functions in emergencies.
- **Functions**:
  - `stopContract()`: Pauses the contract.
  - `resumeContract()`: Resumes contract activity.
 
### EternalStorage Contract
-	**Purpose**: Implements storage that persists through contract upgrades.
-	**Functions**:
    - `upgradeVersion()`: Registers the new version of the contract.
    - `setUint()`, `getUint()`: Manage persistent data storage for campaigns.

### CrowdfundingFactory Contract
- **Purpose**: Manages the creation of new crowdfunding projects.
- **Key Features**:
  - Charges a fee of 0.001 Ether for creating a project.
  - Stores project information, including title, deadline, and funding goal.
  - Emits events when a project is created.
- **Key Functions**:
  - `startProject()`: Creates a new Crowdfunding contract.
  - `returnAllProjects()`: Returns all active campaigns.
    
### Crowdfunding Contract
- **Purpose**: Manages individual crowdfunding campaigns.
- **States**: The contract tracks three states: Fundraising, Expired, and Successful.
- **Key Functions**:
  - `contribute()`: Allows users to contribute Ether to a project.
  - `checkIfFundingCompleteOrExpired()`: Verifies whether the funding goal has been met or the deadline has passed.
  - `payOut()`: Sends the raised funds to the project creator.
  - `getRefund()`: Refunds contributions if the project fails.
    

## Security Features
- Emergency Stop: Contracts can be stopped or resumed in emergencies to prevent exploitation.
- Reentrancy Protection: Ensures secure Ether transfers using the ReentrancyGuard mechanism.
- Ownership: Only the owner of the contract can execute certain critical functions, such as stopping or upgrading the contract.

## Deployment and Interaction
Deployment Steps:
  - Deploy CrowdfundingFactory.
  - Use the factory to create multiple Crowdfunding campaigns.

Web3.js Integration: The platform integrates with Web3.js to allow users to interact with the contracts via a frontend, enabling contributions and monitoring campaign status in real-time.

## Future Enhancements
- Dynamic Fee Management: The fee structure for creating campaigns can be adjusted or eliminated based on platform growth.
- Upgradeable Contracts: Eternal storage allows upgrading contracts without losing data.




