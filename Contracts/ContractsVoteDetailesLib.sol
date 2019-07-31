pragma solidity ^ 0.5.1;

/**
@title  ContractsVoteDetailesLib 
@author  Elders Team
@notice compatible with  v0.5.10 commit.5a6ea5b1 
* @dev ContractsVoteDetailesLib   is a helper library  
*/

 

library ContractsVoteDetailesLib {
/**
 * @dev contracts vote details
 * @param  ContractAddress : is the contract address to vote on
 * @param  ContractRole : is the contract role as your logic Increased
 * @param  IsForAdd : true if voting is for adding new contract
 * @param  VotersCount : total count for all voters Increased according to each vote
 * @param  AgrredVoicesCount : total count for all agreed  voices Increased according to each vote
*/
struct  ContractVoteDetails {
    address  ContractAddress;
    uint ContractRole;
    bool IsForAdd;
    uint VotersCount;
    uint AgrredVoicesCount;
    }
/**
 * @dev if Temp Contract Vote Is Empty or not
 *  if any elder voted yet owner can not edit contract vote details
*/
function TempContractVoteIsEmpty(ContractVoteDetails storage _ContractVoteDetails)internal view returns(bool){
    return _ContractVoteDetails.VotersCount==0 ;
    }
/**
 * @dev if Temp Contract Vote Details Is Empty or not
*/
        function   ContractVoteDetailsValid(ContractVoteDetails storage _ContractVoteDetails)internal view returns(bool){
              return _ContractVoteDetails.ContractAddress != address(0)&&_ContractVoteDetails.ContractRole !=0 ;
 
          }
/**
 * @dev Set ContractVoteDetails
 * TempContractVote has t be Empty
*/
    function SetContractVoteDetails(ContractVoteDetails storage _ContractVoteDetails, address  _contractAddress,
        uint _contractRole,
        bool _isForAdd)
       internal
        {
        _ContractVoteDetails.ContractAddress =_contractAddress;
         _ContractVoteDetails.ContractRole=_contractRole;
         _ContractVoteDetails.IsForAdd=_isForAdd;
    }
/**
 * @dev  getter for vote details for elders review
*/
     function GetContractVoteDetails(ContractVoteDetails storage _ContractVoteDetails)
        public view returns(   address,
        uint,
        bool ,
     uint)
        {
       return ( _ContractVoteDetails.ContractAddress, _ContractVoteDetails.ContractRole ,
       _ContractVoteDetails.IsForAdd,  _ContractVoteDetails.VotersCount  )  ;
    }
      /**
 * @dev to Empty the ContractVoteDetails after voting
 */ 
    function EmptyContractVoteDetails(ContractVoteDetails storage _ContractVoteDetails)
     internal 
      
     {
        _ContractVoteDetails.ContractAddress = address(0);
        _ContractVoteDetails.ContractRole=0;
        _ContractVoteDetails.AgrredVoicesCount=0;
         _ContractVoteDetails.IsForAdd=false;
       
    }
    
   /**
 * @dev New Vote Onlogic contract
 *  ElderAddress has to be exist
 * ElderAddress must not voted before
 * ContractVoteDetai ls Valid
 * ContractVoteTimeSpan > now
 */ 
 
    function NewVoteOnContract(ContractVoteDetails storage _ContractVoteDetails,bool _isAgree) public
    {

        if(_isAgree){ 
           _ContractVoteDetails.AgrredVoicesCount++;
        }  
        _ContractVoteDetails.VotersCount++;
        
    }
 
    
}
