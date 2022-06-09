// SPDX-License-Identifier: Unlicensed


pragma solidity ^0.8.7;

contract FundTheKids {
    //address of the who want the fund
    address owner;

    event LogFundingReceived ( address adrs, uint amount, uint contractBalance);

    constructor() {
        owner = msg.sender;
    }

    struct Kid {
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Kid[] public kids;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public onlyOwner{
        kids.push(Kid(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

   
      function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    function addToKidsBalance(address walletAddress) private {
        for(uint i = 0; i<kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;
                emit LogFundingReceived(walletAddress, msg.value, balanceOf());
            }
        }
    }

    function deposit(address walletAddress) payable public {
        addToKidsBalance(walletAddress);
    }

    function getIndex(address walletAddress) view private returns(uint){
        for(uint i = 0; i< kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i; 
            }
        }

        return 9999;
    }

     function availableToWithdraw(address walletAddress) public returns(bool) {
        uint i = getIndex(walletAddress);

        // if the time setting up to 15 minutes it can be manipulating cause of the block.timestamp
        require(block.timestamp > kids[i].releaseTime, "You cannot withdraw yet");
        if (block.timestamp > kids[i].releaseTime) {
            kids[i].canWithdraw = true;
            return true;
        } else {
            return false;
        }
    }

    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "You must be the kid to withdraw");
        require(kids[i].canWithdraw == true, "You are not able to withdraw at this time");
        kids[i].walletAddress.transfer(kids[i].amount);
    }

}