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
    
      modifier TempElderVoteIsEmpty(){
          require(_ElderVoteDetails.VotersCount==0 ,"Temp Elder Vote Is not Empty");
          _;
      }
    
        /**
 * @dev if Temp Elder Vote Details Is Empty or not
 */ 
         modifier   ElderVoteDetailsValid(){
              require(_ElderVoteDetails.ElderAddress != address(0) ,"contract data not valid");
             
               _;
          }
          
                  
     /**
 * @dev Set ElderVoteDetails
 * TempContractVote has t be Empty
 */ 
    
    function SetElderVoteDetails( address  _elderAddress,
       
        bool _isForAdd)
        public 
        TempContractVoteIsEmpty()
        SenderIsOwner(msg.sender)
        {
        _ElderVoteDetails =ElderVoteDetails (_elderAddress,
           _isForAdd,0,0);
    }
            
                     
     /**
 * @dev  getter for vote details for elders review
 */ 
     function GetElderVoteDetails()
        public view returns(   address,
      
        bool ,
     uint)
        {
       return ( _elderVoteDetails.ElderAddress ,
       _ElderVoteDetails.IsForAdd,  _ElderVoteDetails.VotersCount  )  ;
    }
      /**
 * @dev to Empty the ElderVoteDetails after voting
 */ 
    function EmptyElderoteDetails()
     internal 
        TempElderVoteIsEmpty()
        SenderIsOwner(msg.sender)
     {
        _ElderVoteDetails.ElderAddress = address(0);
 
        _ElderVoteDetails.AgrredVoicesCount=0;
         _ElderVoteDetails.IsForAdd=false;
         SetElderVoteEndTimeSpan(0);
    }
 
    
}