// SPDX-License-Identifier: Unlicensed
//REMIX IDE

pragma solidity >0.7.0 <=0.9.0; // solidity version

contract CampaignFactory {
    address[] public deployedCampaigns;

    event campaignCreated(
        string title,
        uint requiredAmount,
        address indexed owner,
        address campaignAddress,
        string imgURI,
        uint indexed timestamp,
        string indexed category
    );

    function createCampaign(
        string memory campaignTitle, 
        uint requiredCampaignAmount, 
        string memory imgURI, 
        string memory category,
        string memory storyURI) public
    {

        Campaign newCampaign = new Campaign(
            campaignTitle, requiredCampaignAmount, imgURI, storyURI, msg.sender);
        

        deployedCampaigns.push(address(newCampaign));

        emit campaignCreated(
            campaignTitle, 
            requiredCampaignAmount, 
            msg.sender, 
            address(newCampaign),
            imgURI,
            block.timestamp,
            category
        );

    }
}


contract Campaign {              
    string public title;          //Declaring state variables in Storage (drive), permanent 
    uint public requiredAmount;   //Declaring state variables in Storage (drive), permanent
    string public image;          //Declaring state variables in Storage (drive), permanent
    string public story;          //Declaring state variables in Storage (drive), permanent
    address payable public owner; //Declaring state variables in Storage (drive), permanent
    uint public receivedAmount;   //Declaring state variables in Storage (drive), permanent

    event donated(address indexed donar, uint indexed amount, uint indexed timestamp);

    constructor(
        string memory campaignTitle, // Declaring variable in Memory (RAM), temporary 
        uint requiredCampaignAmount, // Declaring variable in Memory (RAM), temporary 
        string memory imgURI,        // Declaring variable in Memory (RAM), temporary 
        string memory storyURI,      // Declaring variable in Memory (RAM), temporary 
        address campaignOwner        // Declaring variable in Memory (RAM), temporary 
    ) {
        title = campaignTitle;
        requiredAmount = requiredCampaignAmount;
        image = imgURI;
        story = storyURI;
        owner = payable(campaignOwner);
    }

    function donate() public payable {
        require(requiredAmount > receivedAmount, "required amount fullfilled");
        owner.transfer(msg.value);
        receivedAmount += msg.value;
        emit donated(msg.sender, msg.value, block.timestamp);
    }
}
