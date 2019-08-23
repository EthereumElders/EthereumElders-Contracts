const EldersRole = artifacts.require('EldersRole');
const EldersVote = artifacts.require('EldersVote');
const SampleVoting = artifacts.require('SampleVoting');

// Example contract for testing

module.exports = function(deployer) {
  // Deploy the libs for testing
  deployer.deploy(EldersRole);
  deployer.deploy(EldersVote);
  // Link contracts for libs
  deployer.link(EldersVote, SampleVoting);


  // deploy the contracts
  deployer.deploy(SampleVoting);

};
