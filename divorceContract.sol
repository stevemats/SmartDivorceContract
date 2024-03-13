/*
Smart Divorce Contract (SDC)
----------------------------

Purpose:
- Streamline and automate divorce proceedings to reduce complexity and length of legal processes.
- Enhance transparency by recording divorce actions on the blockchain, reducing disputes.
- Prioritize privacy by allowing only authorized parties to access and interact with sensitive information.
- Improve enforceability of decisions made during divorce proceedings, reducing future conflicts.

Technologies Used:
- Solidity: The programming language for writing smart contracts on the Ethereum blockchain.
- Ethereum: The blockchain platform where the smart contract is deployed.
- Remix IDE: An online IDE for Ethereum smart contract development and testing.

*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

contract DivorceContract {
    address public husband;
    address public wife;
    address public lawyer;
    
    bool public divorcePending;
    bool public divorced;
    string public reasonForDivorce;

    event DivorceInitiated(address indexed initiator, string reason);
    event DivorceFinalized(address indexed husband, address indexed wife, string reason);

    modifier onlyAuthorized() {
        require(msg.sender == husband || msg.sender == wife || msg.sender == lawyer, "Unauthorized");
        _;
    }

    constructor(address _wife, address _lawyer) {
        husband = msg.sender;
        wife = _wife;
        lawyer = _lawyer;
    }

    function initiateDivorce(string memory _reason) external onlyAuthorized {
        require(!divorcePending && !divorced, "Divorce already pending or finalized");
        
        divorcePending = true;
        reasonForDivorce = _reason;
        emit DivorceInitiated(msg.sender, _reason);
    }

    function finalizeDivorce() external onlyAuthorized {
        require(divorcePending && !divorced, "No pending divorce");
        
        divorced = true;
        divorcePending = false;
        emit DivorceFinalized(husband, wife, reasonForDivorce);
    }

    function getDivorceStatus() external view returns (bool, bool, string memory) {
        return (divorcePending, divorced, reasonForDivorce);
    }

    function getContractDetails() external view returns (address, address, address) {
        return (husband, wife, lawyer);
    }
}
