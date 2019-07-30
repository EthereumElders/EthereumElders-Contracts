pragma solidity ^ 0.5.1;

/**
@title  EldersLogicManag
@author  Elders Team
@notice compatible with  v0.5.10 commit.5a6ea5b1 
 * @dev EldersLogicManag is a base contract for managing add or remove logic contracts ,
 * allowing Elders to add or remove logic contracts
*/

import "./EldersUtilities.sol";
import "./EldersVotingManag.sol";
contract EldersLogicManag is EldersVotingManag
{
 
       address _owner;
 /** 
 * @dev Add default elders array to Elders list in EldersVotingManag contract 
 */
    constructor(
        address[] memory  eldersAddresses,
        uint  minimumEldersPercentageToVote 
       
    ) public    ValIsBetween( minimumEldersPercentageToVote ,100,1){
        AddAddressesToElders(eldersAddresses,minimumEldersPercentageToVote);
        _owner = msg.sender; 
    }
    
 
      /** 
 * @dev mapping to store allowed logic contracts roles for contracts from 1 to i+1 need fixing
 */
        mapping(address=>uint) private _allowedLogicContracts;
    
 
    
      //modifires
 
             modifier AddressIsOwner(address _address){
             require(_address== _owner,"address is not for owner");
          _;   
          }
 
          
         modifier  ContractVoteDetailsNotEmpty(){
              require(_ContractVoteDetails.ContractAddress != address(0)&&_ContractVoteDetails.ContractRole !=0 ,"contract data not valid");
             
               _;
          }
 
      function AddNewLogicContract(address _contractAddress) public AddressIsOwner(msg.sender) ContractVoteDetailsNotEmpty(){
         require(GetContractVoteResult( _contractAddress),"elders refused this contract");
         require( _ContractVoteDetails.IsForAdd,"voting is not for adding contract");
          _allowedLogicContracts[ _ContractVoteDetails.ContractAddress]=  _ContractVoteDetails.ContractRole;
           EmptyContractVoteDetails();
      } 
      
      function RemoveLogicContract(address _contractAddress) public AddressIsOwner(msg.sender) ContractVoteDetailsNotEmpty(){
         require(GetContractVoteResult( _contractAddress),"elders refused this contract");
         require( _ContractVoteDetails.IsForAdd==false,"voting is not for removing contract");
          _allowedLogicContracts[ _ContractVoteDetails.ContractAddress]= 0;
           EmptyContractVoteDetails();
      } 
      
      function LogicContractIsValid(address _contractAddress,uint _role) internal view returns(bool){
          return _allowedLogicContracts[_contractAddress]==_role ;
      }
      
         
}
