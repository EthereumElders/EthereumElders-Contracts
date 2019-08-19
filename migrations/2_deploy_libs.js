const EldersRole = artifacts.require('EldersRole');
const EldersVote = artifacts.require('EldersVote');

module.exports = function(deployer) {
  deployer.deploy(EldersRole);
  deployer.deploy(EldersVote);
};
