// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;
   
  mapping ( address => uint256 ) public balances;

  uint256 public constant threshold = 1 ether;
  uint256 public deadline = block.timestamp + 72 hours;

  

  event Stake(address indexed sender, uint256 amount);
  //event Withdraw(address indexed sender, uint256 amount);

  constructor(address exampleExternalContractAddress)  {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }  
  
    modifier deadlineReached() {
    uint256 timeRemaining = timeLeft();
    require(timeRemaining == 0, "Deadline is not reached yet");
    _;
  }


  modifier deadlineRemaining() {
    uint256 timeRemaining = timeLeft();
    require(timeRemaining > 0, "Deadline is already reached");
    _;
  }


    modifier stakeNotCompleted() {
    bool completed = exampleExternalContract.completed();
    require(!completed, "staking process already completed");
    _;
  }
  
   bool public openForWithdraw = false;
 
  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )

    function stake() public payable deadlineRemaining stakeNotCompleted {
      balances[msg.sender] += msg.value;
      emit Stake(msg.sender, msg.value);
    }

    function withdraw() public deadlineReached stakeNotCompleted {
      require(balances[msg.sender] > 0, "You don't have balance to withdraw");
      
      uint256 amount = balances[msg.sender];
      balances[msg.sender] = 0;

    
    (bool sent, ) = msg.sender.call{value: amount}("");
    require(sent, "Failed to send user balance back to the user");


    //emit Withdraw(msg.sender, amount);    
  }



 // After some `deadline` allow anyone to call an `execute()` function
//  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

  function execute() public stakeNotCompleted deadlineReached {
   if(address(this).balance >= threshold)
      {(exampleExternalContract.complete){value: address(this).balance}();} 
      else {openForWithdraw = true;} 

  }


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
   function timeLeft() public view returns (uint256 timeleft) {
    if (block.timestamp >= deadline) {
      return 0;
    } else {
      return deadline - block.timestamp;
    }
  }
}