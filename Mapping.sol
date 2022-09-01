// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

 contract Mapping {
     
     //Mapping from address to uint in here
     mapping(address => uint) public firstMap;

     function get ( address _addr) public view returns (uint){

         return firstMap[_addr];
     }


     function set ( address _addr, uint _i) public {

         //Update the value at this address
         firstMap[_addr] = _i;
     }

     function remove (address _addr) public {

         // Reset the value to the default value
         delete firstMap[_addr];
     }
 }