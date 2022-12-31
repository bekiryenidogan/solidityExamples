// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FeeCollector {

    address public owner;
    uint256 public balance;


    constructor(){
        owner = msg.sender;
    }

    receive() external  payable {
        balance += msg.value;
    }

    function withdraw(uint256 amount, address payable destAddr) public {
        require(msg.sender == owner,"only owner can withdraw");
        require(amount <= balance,"insufficient funds");

        destAddr.transfer(amount);
        balance -= amount;
    }
}