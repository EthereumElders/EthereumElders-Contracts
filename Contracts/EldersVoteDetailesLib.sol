pragma solidity ^ 0.5.1;

/**
@title  EldersVoteDetailesLib 
@author  Elders Team
@notice compatible with  v0.5.10 commit.5a6ea5b1 
* @dev EldersVoteDetailesLib   is a helper library  
*/

 

library EldersVoteDetailesLib {
     
    /**
 * @dev Elders vote details
 * @param  EldersForVoteAddress : is the elder address to vote on 
 *  @param  IsForAdd : true if voting is for adding new contract
 *  @param  VotersCount : total count for all voters Increased according to each vote
 *  @param  AgrredVoicesCount : total count for all agreed  voices Increased according to each vote
 */ 
     struct ElderVoteDetails {
        address  EldersForVoteAddress;
        bool IsForAdd;
       uint VotersCount;
   uint AgrredVoicesCount;
    }
    
 
    
    
    
      /**
 * @dev if Temp Elder Vote Is Empty or not
 *  if any elder voted yet owner can not edit Elder vote details
 */ 
    
     function TempElderVoteIsEmpty(ElderVoteDetails storage _ElderVoteDetails)internal view returns(bool){
          return _ElderVoteDetails.VotersCount==0 ;
      }
    
        /**
 * @dev if Temp Elder Vote Details Is Empty or not
 */ 
        function   ElderVoteDetailsValid(ElderVoteDetails storage _ElderVoteDetails)internal view returns(bool){
              return _ElderVoteDetails. EldersForVoteAddress != address(0)  ;
 
          }
          
          
                  
   
   
      /**
 * @dev to Empty the ElderVoteDetails after voting
 */ 
    function EmptyElderVoteDetails(ElderVoteDetails storage _ElderVoteDetails) internal
    {
        _ElderVoteDetails.EldersForVoteAddress = address(0);
        _ElderVoteDetails.AgrredVoicesCount=0;
        _ElderVoteDetails.IsForAdd=false;
    }
      /**
 * @dev Set ElderVoteDetails
 * TempContractVote has t be Empty
 */ 
    
    function SetElderVoteDetails(ElderVoteDetails storage _ElderVoteDetails, address  _elderAddress,
        bool _isForAdd)
        internal{
            _ElderVoteDetails.EldersForVoteAddress=_elderAddress;
            _ElderVoteDetails.IsForAdd=_isForAdd;
            }
    
  /**
 * @dev  getter for vote details for elders review
 */ 
     function GetElderVoteDetails(ElderVoteDetails storage _ElderVoteDetails)
        internal  view returns(address, bool, uint)
        {
            return (
                _ElderVoteDetails.EldersForVoteAddress,
                _ElderVoteDetails.IsForAdd,
                _ElderVoteDetails.VotersCount
            );
        }
    function NewVoteOnElder(ElderVoteDetails storage _ElderVoteDetails,bool _isAgree) internal
    {
        if(_isAgree){ 
           _ElderVoteDetails.AgrredVoicesCount++;
        }  
        _ElderVoteDetails.VotersCount++;
    }
}
