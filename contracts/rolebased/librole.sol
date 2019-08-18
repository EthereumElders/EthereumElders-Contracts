/*
 * Copyright 2019 Ethereum Elders Team
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, subject to the conditions of MIT License.
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
 * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

pragma solidity ^0.5.1;

import {EldersRoleUtilities} from "./utils.sol";

/**
* Ethereum Elders role management library supports 256 different roles to
* provide governance over smart contracts via a role based access control (RBAC)
*/
library EldersRole{
//  Error statements constant definition

    //  Out of limit error statement
    string public constant ERR_ROLE_OUT_OF_LIMIT = "role is out of limit";
    //  Rejection error statement
    string public constant ERR_ACCOUNT_NOT_ALLOWED = "account does not have the role permission";


    //  Role table structure definition
    struct RoleTable {
        //        Maps every address to role byte representation in the role table
        mapping (address => uint256) Role;
        //        Maximum number of different roles allowed in the role table
        uint8 MaximumRoles;
    }

    //  Event to declare the change of role per account
    event Role (address, uint256);

    /**
    * Assigns the maximum number of roles allowed to a role table
    * @param maximumRoles uint8 - maximum role number
    */
    function SetMaximumRoles (RoleTable storage self, uint8 maximumRoles) internal {
        self.MaximumRoles = maximumRoles;
    }

    /**
    * Sets a pre-formatted uint256 role to a specific account address in the role table
    * @param account address - the address of the account
    * @param role uint256 - the role in the bytes representation
    */
    function SetRole (RoleTable storage self, address account, uint256 role) internal {
        require(role < EldersRoleUtilities.RoleNumberToBytes(self.MaximumRoles + 1) || self.MaximumRoles == 0xFF,
            ERR_ROLE_OUT_OF_LIMIT);
        self.Role[account] = role;
        emit Role(account, role);
    }

    /**
    * Adds a role number to a specific account address in the role table
    * @param account address - the address of the account
    * @param roleNumber uint8 - the role number ranging 0:255
    */
    function AddRole (RoleTable storage self, address account, uint8 roleNumber) internal {
        require(roleNumber <= self.MaximumRoles, ERR_ROLE_OUT_OF_LIMIT);
        self.Role[account] = EldersRoleUtilities.AddToRole(self.Role[account], roleNumber);
        emit Role (account, self.Role[account]);
    }

    /**
    * Removes a role number from a specific account address in the role table
    * @param account address - the address of the account
    * @param roleNumber uint8 - the role number ranging 0:255
    */
    function RemoveRole (RoleTable storage self, address account, uint8 roleNumber) internal {
        require(roleNumber <= self.MaximumRoles, ERR_ROLE_OUT_OF_LIMIT);
        self.Role[account] = EldersRoleUtilities.RemoveFromRole(self.Role[account], roleNumber);
        emit Role (account, self.Role[account]);
    }

    /**
    * Checks if a role number exists for a specific account address in the role table
    * @param account address - the address of the account
    * @param roleNumber uint8 - the role number ranging 0:255
    */
    function RoleExists (RoleTable storage self, address account, uint8 roleNumber) view internal returns (bool) {
        return EldersRoleUtilities.RoleExists(self.Role[account], roleNumber);
    }
}