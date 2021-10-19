const Token = artifacts.require("Token");
const dBank = artifacts.require("dBank");
var WhatToken = artifacts.require("WhatToken");
var WhatTokenSale = artifacts.require("WhatTokenSale");
var SafeMath = artifacts.require("SafeMath");

module.exports = async function (deployer) {
  // Safe Math
  await deployer.deploy(SafeMath);
  deployer.link(SafeMath, WhatToken);

  // What Token
  await deployer.deploy(WhatToken, "WhatToken", "WHAT", 1000000);
  // Token price is 0.001 Ether
  var tokenPrice = 1000000000000000;
  const whatToken = await WhatToken.deployed();

  // What Token Sale
  await deployer.deploy(WhatTokenSale, whatToken.address, tokenPrice);

  //deploy Token
  await deployer.deploy(Token);

  //assign token into variable to get it's address
  const token = await Token.deployed();

  //pass token address for dBank contract(for future minting)
  await deployer.deploy(dBank, token.address);

  //assign dBank contract into variable to get it's address
  const dbank = await dBank.deployed();

  //change token's owner/minter from deployer to dBank
  await token.passMinterRole(dbank.address);
};
