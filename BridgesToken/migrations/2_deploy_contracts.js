const ERC20 = artifacts.require("ERC20");
const ERC223 = artifacts.require("ERC223");
const ERC223ReceivingContract = artifacts.require("ERC223ReceivingContract");
const BridgesToken = artifacts.require("BridgesToken");

module.exports = function (deployer) {
  deployer.deploy(ERC20);
  deployer.deploy(ERC223);
  deployer.deploy(ERC223ReceivingContract);
  deployer.deploy(BridgesToken);
};
