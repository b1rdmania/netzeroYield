// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract MockRaylsIdentityRegistry {
    mapping(address => bool) private accreditedInvestors;
    address public owner;

    event InvestorAccredited(address indexed investor);
    event AccreditationRevoked(address indexed investor);

    constructor() {
        owner = msg.sender;
    }

    function isAccredited(address account) external view returns (bool) {
        return accreditedInvestors[account];
    }

    function grantAccreditation(address investor) external {
        require(msg.sender == owner, "Only owner");
        accreditedInvestors[investor] = true;
        emit InvestorAccredited(investor);
    }

    function revokeAccreditation(address investor) external {
        require(msg.sender == owner, "Only owner");
        accreditedInvestors[investor] = false;
        emit AccreditationRevoked(investor);
    }

    function batchGrantAccreditation(address[] calldata investors) external {
        require(msg.sender == owner, "Only owner");
        for (uint256 i = 0; i < investors.length; i++) {
            accreditedInvestors[investors[i]] = true;
            emit InvestorAccredited(investors[i]);
        }
    }
}

