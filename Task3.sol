// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0; 

contract DynamicArray {

    struct Account {
        string name;
        string surname;
        uint256 balance;
    }
    
         uint private index;

        Account[] public admins;

/* Paribu Hub Solidity Bootcamp Task 3
Derste işlerken kullandığımız aşağıdaki metot için bazı düzenlemeler yapılması gerekmektedir.
Metot dönüş değerini Sabit bir dizi olarak değil eklendiği kadar elemanla döndüren bir yapıya
dönüştürülmesi amaçlanmaktadır. 
*/
 function getAllAdmins() public view returns(Account[] memory) {
    uint256 length = admins.length;
    Account[] memory _admins = new Account[](length);
    for(uint i=0;i<length;i++){
        _admins[i] = admins[i];
    }

    return _admins;
}
    
    function addAdmin(Account memory admin) public {
       require(index<3, "Has no slot");
        admins[index++] = admin;
    }
}