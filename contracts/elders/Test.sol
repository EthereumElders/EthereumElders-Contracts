pragma solidity ^ 0.5.1;

/**
@title   Certs Ledger 
@author  Elders Team
@notice compatible with  v0.5.10 commit.5a6ea5b1 
*/

import "./EldersRoles.sol";
import "./EldersLogicManag.sol";
import "./EldersVotingManag.sol";
contract test is EldersVotingManag,EldersLogicManag {
    
    
     constructor(
         address[] memory  eldersAddresses,
        uint  minimumEldersPercentageToVote 
        
    ) public   EldersLogicManag(
        eldersAddresses,
          minimumEldersPercentageToVote 
       
    ){
        
        _owner = msg.sender; 
    }
    
    
     using EldersRoles for EldersRoles.Roles;
     
        EldersRoles.Roles private _roles;
      
       
        function addRoleToAccount(address _account ,uint _role )public{
            _roles.AddRoleToAccount(_role,_account);
        }
        
        function setMaxRollArrayVal(uint8 val)internal{
            require( LogicContractIsValid(msg.sender,1),"sender has no access to this func");
              _roles.SetMaxRolesArrayLength(val);
        }
        
        
      
}
