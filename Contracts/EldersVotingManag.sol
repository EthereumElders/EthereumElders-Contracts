pragma solidity ^ 0.5 .1;

/**
 *@title  EldersVotingManag
 *@author  Elders Team
 *@notice compatible with  v0.5.10 commit.5a6ea5b1 
 * @dev EldersVotingManag is a base contract for managing logic contracts and elders voting,
 * allowing Elders to vote on adding or removing Elder or logic contract
 */

import "./EldersUtilities.sol";
import "./ContractsVoteDetailesLib.sol";
import "./EldersVoteDetailesLib.sol";
contract EldersVotingManag {

    using EldersUtilities
    for address[];
    using ContractsVoteDetailesLib
    for ContractsVoteDetailesLib.ContractVoteDetails;
    using EldersVoteDetailesLib
    for EldersVoteDetailesLib.ElderVoteDetails;
    //parameters
    address private _owner;
    /**
     * @dev all elders count 
     * Increased or decreased according to the addition or deletion of each Elder
     */
    uint private _eldersCount;
    /**
     * @dev minimum Elders Percentage for acceptable Voting 
     * Uint number from 1 to 100 to be  set in the constructor 
     */
    uint private _minimumEldersPercentageToVote;
    /**
     * @dev if contract Is dirty or not
     * used to restrict adding default elders list to Elders 
     */
    bool private _contractIsConstructed = false;

    /**
     * @dev end voting time span variables
     */
    uint private _contractVoteTimeSpan;
    uint private _elderVoteTimeSpan;


    constructor(

    ) public {

        _owner = msg.sender;
    }



    //events


    /**
     * @dev storages to save vote details in it
     * if it empty you can not vote or add contracts
     * if any elder voted yet owner can not edit  vote details
     * to be empty after voting is must
     */
    ContractsVoteDetailesLib.ContractVoteDetails internal _ContractVoteDetails;
    EldersVoteDetailesLib.ElderVoteDetails private _ElderVoteDetails;


    //mappings

    /**
     * @dev Temp storage for contracts voting
     * to map elder account address to 1 if agreed or 2 if not agreed or 0 if empty 
     */
    mapping(address => uint) private TempContractVote;
    /**
     * @dev Temp storage for elders voting
     * to map elder account address to 1 if agreed or 2 if not agreed or 0 if empty 
     */
    mapping(address => uint) private TempElderVote;
    /**
     * @dev all elders in app 
     * map the elder address account to true after voting on adding him is succeeded
     * map the elder address account to false after voting on removing him is succeeded
     */
    mapping(address => bool) private Elders;



    //modifires
    /** @notice has to move to utilities contract
     */
    modifier ValIsBetween(uint _val, uint _maxVal, uint _minVal) {
        bool result = _val >= _minVal && _val <= _maxVal;
        require(result, "value is out of limit");
        _;
    }
    /**
     * @dev if Temp Contract Vote Is Empty or not
     *  if any elder voted yet owner can not edit contract vote details
     */

    modifier TempContractVoteIsEmpty() {
        require(_ContractVoteDetails.VotersCount == 0, "Temp Contract Vote Is not Empty");
        _;
    }

    modifier SenderIsOwner(address _senderAddress) {
        require(_senderAddress == _owner, "sender is not the owner");
        _;
    }
    /**
     * @dev if elder account is exist 
     * if you want to modifier that elder is exist set _hasToBe to true
     * else set it to false
     */
    modifier ElderAddressIsValid(address _elderAddress, bool _hasToBe) {
        require(Elders[_elderAddress] == _hasToBe, " Elder address as not valid");
        _;
    }
    modifier ElderVoteNotExist(address _elderAddress) {
        require(TempElderVote[_elderAddress] == 0, "Elder Vote for this elder is Exist");
        _;
    }
    
    modifier ElderVoteDetailsIsValid(){
        require(_ElderVoteDetails.ElderVoteDetailsValid(), "elder data not valid");
        _;
    }
    modifier ElderVoteTimeSpanIsValid(){
        require(_elderVoteTimeSpan > now, "Elder Vote TimeSpan Is not Valid");
        _;
    }
    modifier TempElderVoteIsEmpty() {
        require(_ElderVoteDetails.VotersCount == 0, "Temp Elder Vote Is not Empty");
        _;
    }
    /**
     * @dev if  elder account Address had been voted before on the current contract
     */
    modifier ContractVoteNotExist(address _elderAddress) {
        require(TempContractVote[_elderAddress] == 0, "Contract Vote for this elder is Exist");
        _;
    }
    /**
     * @dev if Temp Contract Vote Details Is Empty or not
     */
    modifier ContractVoteDetailsIsValid() {
        require(_ContractVoteDetails.ContractVoteDetailsValid(), "contract data not valid");

        _;
    }

    modifier ContractVoteTimeSpanIsValid() {
        require(_contractVoteTimeSpan > now, "Contract Vote TimeSpan Is not Valid");
        _;
    }
    /**
     * @dev modify the voting result
     */
    modifier EldersVotersPersentageIsValid() {
        uint votersCount = _ContractVoteDetails.VotersCount;
        uint voterPersent = 100 * (votersCount / _eldersCount);
        require(voterPersent > 50, "Voters Persentage Is not Valid");
        _;
    }



    //functions  

    /**
     * @dev add default elders to Elders mapp and set minimum Elders Percentage to eccept Voting
     * to be implemented from EldersLogicManag
     */
    function AddAddressesToElders(address[] memory _elderAddresses, uint minimumEldersPercentageToVote) internal SenderIsOwner(msg.sender) {
        require(_contractIsConstructed == false, "AddAddressesToElders is used before");

        _eldersCount = _elderAddresses.length + 1;
        for (uint i = 0; i < _elderAddresses.length; i++) {
            Elders[_elderAddresses[i]] = true;
        }

        Elders[_owner] = true;
        _minimumEldersPercentageToVote = minimumEldersPercentageToVote;
        _contractIsConstructed = true;
    }


    /**
     * @dev Set ContractVoteDetails
     * TempContractVote has t be Empty
     */

    function SetContractVoteDetails(address _contractAddress,
        uint _contractRole,
        bool _isForAdd)
    public
    TempContractVoteIsEmpty()
    SenderIsOwner(msg.sender) {
        _ContractVoteDetails.SetContractVoteDetails(_contractAddress, _contractRole, _isForAdd);
    }
    /**
     * @dev  getter for vote details for elders review
     */
    function GetContractVoteDetails()
    public view returns(address,
        uint,
        bool,
        uint) {
        return _ContractVoteDetails.GetContractVoteDetails();
    }
    /**
     * @dev to Empty the ContractVoteDetails after voting
     */
    function EmptyContractVoteDetails()
    internal
    TempContractVoteIsEmpty()
    SenderIsOwner(msg.sender) {
        _ContractVoteDetails.EmptyContractVoteDetails();
        SetContractVoteEndTimeSpan(0);
    }

    /**
     * @dev  Vote On new logic contract
     *  ElderAddress has to be exist
     * ElderAddress must not voted before
     * ContractVoteDetai ls Valid
     * ContractVoteTimeSpan > now
     */

    function VoteOnNewContract(address _elderAddress, bool _isAgree) public
    ElderAddressIsValid(_elderAddress, true) ContractVoteNotExist(_elderAddress) ContractVoteDetailsIsValid() ContractVoteTimeSpanIsValid() {
        uint result = 0;
        if (_isAgree) {
            result = 1;
        } else {
            result = 2;
        }

        TempContractVote[_elderAddress] = result;
        _ContractVoteDetails.NewVoteOnContract(_isAgree);

    }

    function SetContractVoteEndTimeSpan(uint _endVoteTimeSpan) public SenderIsOwner(msg.sender) {
        _contractVoteTimeSpan = _endVoteTimeSpan;
    }

    function SetElderVoteEndTimeSpan(uint _endVoteTimeSpan) public SenderIsOwner(msg.sender) {
        _elderVoteTimeSpan = _endVoteTimeSpan;
    }
    /**
     * @dev  Get Contract Vote Result
     *  Voters Persentage has to be Valid
     *  ContractVoteTimeSpan>now
     * _contractAddress has to equal the _ContractVoteDetails.ContractAddress
     *vote result has to be greater than 50%
     */
    function GetContractVoteResult(address _contractAddress) public view
    EldersVotersPersentageIsValid() ContractVoteTimeSpanIsValid() returns(bool _result) {
        require(_contractAddress == _ContractVoteDetails.ContractAddress, "contract address not valid");
        uint result = 100 * (_ContractVoteDetails.AgrredVoicesCount / _ContractVoteDetails.VotersCount);
        return result >= 50;
    }
 
    /**
   
       function SetElderVoteDetails( address  _elderAddress,
        bool _isForAdd)
        public 
        TempElderVoteIsEmpty()
        SenderIsOwner(msg.sender)
        {
        _ElderVoteDetails =ElderVoteDetails ( _elderAddress,
           _isForAdd,0,0);
    }
    
     function AddNewElderVote(_elderAddress ,_isAgree);
 
      function SetElderVoteEndTimeSpan(_endVoteTimeSpan);
     function GetElderVoteResult(_elderAddress,_isForAdd);
     function AddNewElder(_elderAddress);
     function GetEldersVoteDetails()
     */

     function GetElderVoteDetails() public view returns(address,
        bool,
        uint) {
        return _ElderVoteDetails.GetElderVoteDetails();
    }

    function VoteOnElder(address _elderAddress, bool _isAgree) public
    ElderAddressIsValid(_elderAddress, true) ElderVoteNotExist(_elderAddress) ElderVoteDetailsIsValid() ElderVoteTimeSpanIsValid() {
        uint result = 0;
        if (_isAgree) {
            result = 1;
        } else {
            result = 2;
        }
        TempElderVote[_elderAddress] = result;
        _ElderVoteDetails.NewVoteOnElder(_isAgree);
    }

    function EmptyElderVoteDetails() internal TempElderVoteIsEmpty() SenderIsOwner(msg.sender) {
        _ElderVoteDetails.EmptyElderVoteDetails();
        SetElderVoteEndTimeSpan(0);
    }
    
    
    
    function GetElderVoteResult(address _ElderAddress) public view
   EldersVotersPersentageIsValid() ElderVoteTimeSpanIsValid() returns(bool _result) {
        require(_ElderAddress ==  _ElderVoteDetails.EldersForVoteAddress, "Elder address not valid");
        uint result = 100 * (_ElderVoteDetails.AgrredVoicesCount / _ElderVoteDetails.VotersCount);
        return result >= 50;
    }
    function SetElderVoteDetails(address _ElderAddress, 
        bool _isForAdd)
    public
    TempElderVoteIsEmpty()
    SenderIsOwner(msg.sender) {
        _ElderVoteDetails.SetElderVoteDetails(_ElderAddress,  _isForAdd);
    }
    
}
