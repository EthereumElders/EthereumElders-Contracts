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


/**
* Utility library that provides utility functions that works interchangeably with lib EldersRole
*/
library EldersRoleUtilities {
    /**
    * Converts a role number ranging from 0:255 to a uint256 format into a
    * role representation in 256 bit format i.e. true (1) in the role-th bit
    * @param roleNumber uint8 - role as a number
    */
    function RoleNumberToBytes(uint8 roleNumber) pure internal returns (uint256) {
        return (0x01 << uint256(roleNumber));
    }

    /**
    * Checks if role number exists in a role byte format
    * @param role uint256 - role permissions in byte format
    * @param roleNumber uint8 - role as a number
    */
    function RoleExists (uint256 role, uint8 roleNumber) pure internal returns(bool) {
        return ( role & RoleNumberToBytes(roleNumber) ) > 0;
    }

    /**
    * Concatenates a role to a given role format
    * @param role uint256 - role 256 bits format
    * @param roleNumber uint8 - role number ranging from 0:255
    */
    function AddToRole (uint256 role, uint8 roleNumber) pure internal returns (uint256) {
        return role | RoleNumberToBytes(roleNumber);
    }

    /**
    * Removes a role number from a given role format
    * @param role uint256 - role 256 bits format
    * @param roleNumber uint8 - role number ranging from 0:255
    */
    function RemoveFromRole (uint256 role, uint8 roleNumber) pure internal returns (uint256) {
        return role & (~ RoleNumberToBytes(roleNumber));
    }
}
