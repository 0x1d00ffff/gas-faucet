var GasFaucet = artifacts.require("GasFaucet");

module.exports = function(deployer) {
  deployer.deploy(GasFaucet);
};