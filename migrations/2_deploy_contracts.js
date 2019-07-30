const EldersUtilitiesLib = artifacts.require("EldersUtilities");
const EldersRoles = artifacts.require("EldersRoles");
const EldersVotingManag = artifacts.require("EldersVotingManag");
const EldersLogicManag = artifacts.require("EldersLogicManag");
const Test = artifacts.require("Test");
var minPersent = 55;
var addr =["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"];
module.exports = function(deployer) {
  deployer.deploy(EldersUtilitiesLib);
  deployer.link(EldersUtilitiesLib, EldersRoles);
  deployer.deploy(EldersRoles);
  deployer.link(EldersRoles, Test);
  deployer.deploy(Test);

  deployer.link(EldersUtilitiesLib, EldersVotingManag);
  deployer.deploy(EldersVotingManag,addr ,minPersent);
  deployer.link(EldersUtilitiesLib, EldersLogicManag);
  deployer.deploy(EldersLogicManag,addr ,minPersent);
};
