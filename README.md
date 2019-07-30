# <img src="logo.png" alt="EldersContracts" height="40px">


**Elders**  is a library for secure Ethereum smart contract development.It helps you to build custom contracts and more complex decentralized systems.</br>
**By using Elders** you can build a strong authentication roles for your contracts and you can use it's voting system to control your logic
contracts with voting on adding or removing contracts to get roles and access on your storage contracts or even voting on each new elder to join as new </br>
**with Elders** library you will easily get an upgradeable contracts with separation between storage and logic contracts 
**Elders**  Contracts features a stable API, which means your contracts won't break unexpectedly when upgrading to a newer minor version.  

## Usage

To write your custom contracts, import ours and extend them through inheritance.

```solidity
pragma solidity ^ 0.5 .1;

import "./EldersRoles.sol";
import "./EldersLogicManag.sol";
import "./EldersVotingManag.sol";
contract test is EldersVotingManag, EldersLogicManag {

    constructor(
        address[] memory eldersAddresses,
        uint minimumEldersPercentageToVote

    ) public EldersLogicManag(
        eldersAddresses,
        minimumEldersPercentageToVote

    ) {

        _owner = msg.sender;
    }

    using EldersRoles
    for EldersRoles.Roles;

    EldersRoles.Roles private _roles;


    function addRoleToAccount(address _account, uint _role) public {
        _roles.AddRoleToAccount(_role, _account);
    }

    function setMaxRollArrayVal(uint8 val) internal {
        require(LogicContractIsValid(msg.sender, 1), "sender has no access to this func");
        _roles.SetMaxRolesArrayLength(val);
    }


}
```
## contracts

**EldersRoles** 
>@title  EldersUtilities 
>@author  Elders Team
>@notice compatible with  v0.5.10 commit.5a6ea5b1 
>*EldersUtilities is a helper library for uint and addresses  

**EldersRoles** 
>@title  EldersRoles
>@author  Elders Team
>@notice compatible with  v0.5.10 commit.5a6ea5b1 
>* EldersRoles is a helper library for  adding or removing multi roles to accounts
>* first you have to SetMaxRolesArrayLength
>* then use setters and getters to add and remove or validate roles to user

**EldersVotingManags** 
>*@title  EldersLogicManag
>*@author  Elders Team
>*@notice compatible with  v0.5.10 commit.5a6ea5b1 
>* EldersVotingManag is a base contract for managing logic contracts and elders voting,
>* allowing Elders to vote on adding or removing Elder or logic contract

**EldersLogicManag** 
>@title  EldersLogicManag
>@author  Elders Team
>@notice compatible with  v0.5.10 commit.5a6ea5b1 
 >*EldersLogicManag is a base contract for managing add or remove logic contracts ,
 >*allowing Elders to add or remove logic contracts
 
## framework
> You need an ethereum development framework for the above import statements to work! Check out these guides for [Truffle], [Embark] or [Buidler].
 
 Keep in mind that the API docs are work in progress.

## Security

 
## EldersTeam

names here

## License

Elders is released under the [MIT License](LICENSE).

