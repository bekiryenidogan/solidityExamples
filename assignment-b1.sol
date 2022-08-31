// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }
    function getData () public view returns (uint x ){
        return storedData;
    }
    
}