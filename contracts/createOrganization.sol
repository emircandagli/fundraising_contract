// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract CreateOrganization {
    uint public nextOrgId = 1;
    address public owner;
    struct Organization {
        uint id;
        string name;
        string description;
        uint total_amount;
    }

    mapping(uint => Organization) public organizations;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action.");
        _;
    }

    event OrganizationCreated(uint id, string name, string description);

    function createOrganization(string memory _name, string memory _description) public onlyOwner {
        uint orgId = nextOrgId++;
        organizations[orgId] = Organization(orgId, _name, _description, 0);
        emit OrganizationCreated(orgId, _name, _description);
    }

    function getOrganizationDetails(uint _orgId) public view returns (Organization memory) {
        return organizations[_orgId];
    }
    
    function addFundsToOrganization(uint _orgId, uint _amount) public {
        require(organizations[_orgId].id != 0, "Organization does not exist.");
        organizations[_orgId].total_amount += _amount;
    }
}