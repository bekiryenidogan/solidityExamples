pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

   //event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens);

   YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() external payable {
    uint amount = msg.value*tokensPerEth;
    require(amount > 0);

    IERC20(yourToken).transfer(msg.sender, amount);
    emit BuyTokens(msg.sender, msg.value, amount);
  }


  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() external onlyOwner {
    (bool ok , ) = payable(owner()).call{value:address(this).balance}("");
    require(ok,"Call Failed.");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint amount) external {
    uint eth = amount / tokensPerEth;

    IERC20(yourToken).transferFrom(msg.sender, address(this), amount);

    (bool ok , ) = msg.sender.call{value: eth} ("");
    require(ok,"Call Failed");
    emit SellTokens(msg.sender, amount);
  }
}