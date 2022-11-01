// SPDX-License-Identifier: MIT
pragma solidity >=0.7.1 <0.9.0;

//https://medium.com/laykadao/solidity-veri-tipi-string-8585a2b1a183

contract ReverseString {
    function reverseString ( string calldata _str) external pure  returns (string memory){
        bytes memory str = bytes(_str);
        string memory tmp = new string (str.length);
        bytes memory _reversed = bytes(tmp);

        for (uint i = 0; i<str.length; i++) {
            _reversed[str.length -i - 1]= str[i];
        }
        return string (_reversed);
    }
}