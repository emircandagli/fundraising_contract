// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "./createOrganization.sol";

contract Donation {
    address public owner;
    CreateOrganization public createOrgContract;

    struct Donor {
        uint totalDonated;
        uint numberOfDonations;
    }

    constructor(CreateOrganization _createOrgContract) {
        owner = msg.sender;
        createOrgContract = _createOrgContract;
    }

    function createNewOrganization(string memory _name, string memory _description) public {
        createOrgContract.createOrganization(_name, _description);
    }

    mapping(uint => Donor) public donors;

    event DonationReceived(uint orgId, uint amount);

    function donate(uint _orgId) public payable {
        require(msg.value > 0, "You need to send some ether to perform this action");
        require(createOrgContract.getOrganizationDetails(_orgId).id != 0, "Organization does not exist.");

        Donor storage donor = donors[uint(uint160(msg.sender))];
        donor.totalDonated += msg.value;
        donor.numberOfDonations += 1;

        createOrgContract.addFundsToOrganization(_orgId, msg.value); // Bu fonksiyon CreateOrganization kontratında tanımlanmalıdır.

        emit DonationReceived(_orgId, msg.value);
    }


}
