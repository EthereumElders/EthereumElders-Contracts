pragma solidity ^ 0.5 .1;

/**
@title  EldersLogicManag
@author  Elders Team
@notice compatible with  v0.5.10 commit.5a6ea5b1 
 * @dev EldersLogicManag is a base contract for managing add or remove logic contracts ,
 * allowing Elders to add or remove logic contracts
*/

import "./EldersUtilities.sol";
import "./EldersVotingManag.sol";
contract EldersLogicManag is EldersVotingManag {

    address _owner;
    /** 
     * @dev Add default elders array to Elders list in EldersVotingManag contract 
     */
    constructor(
        address[] memory eldersAddresses,
        uint minimumEldersPercentageToVote

    ) public ValIsBetween(minimumEldersPercentageToVote, 100, 1) {
        AddAddressesToElders(eldersAddresses, minimumEldersPercentageToVote);
        _owner = msg.sender;
    }


    /** 
     * @dev mapping to store allowed logic contracts roles for contracts from 1 to i+1 need fixing
     */
    mapping(address => uint) private _allowedLogicContracts;



    //modifires

    modifier AddressIsOwner(address _address) {
        require(_address == _owner, "address is not for owner");
        _;
    }


    modifier ContractVoteDetailsNotEmpty() {
        require(_ContractVoteDetails.ContractAddress != address(0) && _ContractVoteDetails.ContractRole != 0, "contract data not valid");

        _;
    }
    modifier ElderVoteDetailsNotEmpty() {
        require(_ElderVoteDetails.EldersForVoteAddress != address(0), "elder data not valid");

        _;
    }

    //functions

    /** 
     * @dev Adding New Logic Contract after voting by elders
     */
    function AddNewLogicContract(address _contractAddress) public AddressIsOwner(msg.sender) ContractVoteDetailsNotEmpty() {
        require(GetContractVoteResult(_contractAddress), "elders refused this contract");
        require(_ContractVoteDetails.IsForAdd, "voting is not for adding contract");
        _allowedLogicContracts[_ContractVoteDetails.ContractAddress] = _ContractVoteDetails.ContractRole;
        EmptyContractVoteDetails();
    }
    /** 
     * @dev removing existing Logic Contract after voting by elders
     */
    function RemoveLogicContract(address _contractAddress) public AddressIsOwner(msg.sender) ContractVoteDetailsNotEmpty() {
        require(GetContractVoteResult(_contractAddress), "elders refused this contract");
        require(_ContractVoteDetails.IsForAdd == false, "voting is not for removing contract");
        _allowedLogicContracts[_ContractVoteDetails.ContractAddress] = 0;
        EmptyContractVoteDetails();
    }
    /** 
     * @dev check if logic contract address is exist in list 
     * use this func to validate your sender in storage contract
     */
    function LogicContractIsValid(address _contractAddress, uint _role) internal view returns(bool) {
        return _allowedLogicContracts[_contractAddress] == _role;
    }
    /** 
     * @dev Adding New Elder after voting by elders
     */
    function AddNewElder(address _elderAddress) public AddressIsOwner(msg.sender) ElderVoteDetailsNotEmpty() {
        require(GetElderVoteResult(_elderAddress), "elders refused this new elder");
        require(_ElderVoteDetails.IsForAdd, "voting is not for adding elder");
        Elders[_elderAddress] = true;
        EmptyElderVoteDetails();
    }
    /** 
     * @dev removing existing Elder after voting by old elders
     */
    function RemoveExistedElder(address _elderAddress) public AddressIsOwner(msg.sender) ElderVoteDetailsNotEmpty() {
        require(GetElderVoteResult(_elderAddress), "elders refused this new elder");
        require(!_ElderVoteDetails.IsForAdd, "voting is not for removing elder");
        require(_eldersCount > 0, "elders count less than one");
        require(Elders[_elderAddress] == true, "elder not exist");
        Elders[_elderAddress] = false;
        _eldersCount--;
        EmptyElderVoteDetails();
    }
}
