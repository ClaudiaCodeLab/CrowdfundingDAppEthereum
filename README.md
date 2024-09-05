# Crowdfunding DApp

## Introduction

This decentralized application (DApp) is a crowdfunding platform built on the Ethereum blockchain. It allows project creators to launch campaigns, receive contributions in Ether, and manage refunds if fundraising goals are not met.

## Contracts Overview

The DApp consists of several smart contracts, each serving a specific purpose:

1. **Ownable**: Manages contract ownership, restricting certain functions to the owner.
2. **EmergencyStop**: Provides functionality to halt or resume contracts during emergencies.
3. **EternalStorage**: Ensures data persistence across contract upgrades.
4. **CrowdfundingFactory**: Facilitates the creation and management of crowdfunding campaigns, handles fees, and maintains an index of active projects.
5. **Crowdfunding**: Manages contributions, tracks project states (Fundraising, Expired, Successful), and handles payouts or refunds.

## Detailed Contracts Explanation

### Ownable Contract
- **Purpose**: Restricts execution of specific functions to the contract owner.
- **Functions**:
  - `transferOwnership()`: Transfers ownership to a new address.
  - `isOwner()`: Checks if the caller is the owner.

### EmergencyStop Contract
- **Purpose**: Provides emergency control over contract functions.
- **Functions**:
  - `stopContract()`: Pauses contract operations.
  - `resumeContract()`: Resumes contract operations.

### EternalStorage Contract
- **Purpose**: Maintains persistent storage across upgrades.
- **Functions**:
  - `upgradeVersion()`: Registers a new contract version.
  - `setUint()`, `getUint()`: Manage persistent data storage.

### CrowdfundingFactory Contract
- **Purpose**: Manages new crowdfunding projects.
- **Key Features**:
  - Charges a 0.001 Ether fee for project creation.
  - Stores project details such as title, deadline, and funding goal.
  - Emits events when projects are created.
- **Key Functions**:
  - `startProject()`: Initiates a new Crowdfunding contract.
  - `returnAllProjects()`: Lists all active campaigns.

### Crowdfunding Contract
- **Purpose**: Oversees individual crowdfunding campaigns.
- **States**: Tracks Fundraising, Expired, and Successful states.
- **Key Functions**:
  - `contribute()`: Allows Ether contributions to a project.
  - `checkIfFundingCompleteOrExpired()`: Checks if the funding goal is met or the deadline has passed.
  - `payOut()`: Transfers raised funds to the project creator.
  - `getRefund()`: Refunds contributors if the project fails.

## Security Features
- **Emergency Stop**: Allows pausing/resuming contracts to prevent exploitation.
- **Reentrancy Protection**: Uses ReentrancyGuard to secure Ether transfers.
- **Ownership**: Restricts critical functions to the contract owner.

## Deployment and Interaction

- **Deployment Steps**:
  1. Deploy the `CrowdfundingFactory`.
  2. Use the factory to create multiple Crowdfunding campaigns.
- **Web3.js Integration**: The platform integrates with Web3.js for frontend interaction, enabling real-time contributions and campaign monitoring.

## Future Enhancements
- **Dynamic Fee Management**: Adjust or remove campaign creation fees based on platform growth.
- **Upgradeable Contracts**: Use eternal storage for seamless contract upgrades.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
