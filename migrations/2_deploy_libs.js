const EldersRole = artifacts.require('./rolebased/EldersRole');

module.exports = function(deployer) {
  deployer.deploy(EldersRole);
};
