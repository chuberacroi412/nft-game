const LipToken = artifacts.require("LipToken");

module.exports = function (deployer) {
  deployer.deploy(LipToken, "LipToken", "LIP");
};
