// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract RealEstate{

    struct Tenant {
        string name;
        string location;
    } 
    // places for rental
    struct RentalProperty {
        string propertyName;
        uint256 leaseStartDate;
        uint256 leaseEndDate;
        address propertyOwnerAddress;
    }

    Tenant[] public tenants;
    RentalProperty[] public rentalProperties;

    mapping(address => Tenant) public tenantInfo;
    mapping(address => RentalProperty) public propertyInfo;

    event RentedOut (address indexed tenantAddress, string propertyName);
    event Released (address indexed tenantAddress, string propertyName);
    event PropertyAdded(string propertyName, uint256 leaseStartDate, uint256 leaseEndDate, address propertyOwnerAddress);

     function updateTenantInfo (string memory _name, string memory _location) internal  {
        Tenant  storage tenant  = tenantInfo[msg.sender];
        tenant.name = _name;
        tenant.location = _location; 
     }

     function addRentalProperty(string memory _propertyName, uint256 _leaseStartDate, uint256 _leaseEndDate) public{
        require(_leaseStartDate < _leaseEndDate, "Invalid lease dates");
        require(bytes(_propertyName).length > 0, "Property name cannot be empty");
        RentalProperty storage newRentalProperty = propertyInfo[msg.sender];
        newRentalProperty.propertyName = _propertyName;
        newRentalProperty.leaseStartDate = _leaseStartDate;
        newRentalProperty.leaseEndDate = _leaseEndDate;
        newRentalProperty.propertyOwnerAddress = msg.sender;

        rentalProperties.push(newRentalProperty);

        emit PropertyAdded(_propertyName, _leaseStartDate, _leaseEndDate, msg.sender);
    }
    function rentOutProperty(string memory _propertyName, address _tenantAddress) public {
        RentalProperty storage rentalProperty = propertyInfo[msg.sender];
        require(rentalProperty.leaseStartDate != 0, "Rental property not found");
        require(rentalProperty.leaseEndDate > block.timestamp, "Lease period has ended");
        require(msg.sender != _tenantAddress, "You cannot rent out your own property");

        Tenant storage tenant = tenantInfo[_tenantAddress];
        require(bytes(tenant.name).length > 0, "Tenant not found");

        emit RentedOut(_tenantAddress, _propertyName);
    }

    // Release a tenant from a property
    function releaseTenant(string memory _propertyName) public {
        RentalProperty storage rentalProperty = propertyInfo[msg.sender];
        require(rentalProperty.leaseStartDate != 0, "Rental property not found");

        emit Released(msg.sender, _propertyName);
    }
}