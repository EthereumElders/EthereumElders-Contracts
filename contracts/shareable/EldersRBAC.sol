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

import {EldersRole} from "../rolebased/EldersRole.sol";

/**
* Role Based Access Control contract with Ethereum Elders implementation
*/
contract EldersRBAC {
    using EldersRole for EldersRole.RoleTable;

    // Holds the RBAC attributes
    EldersRole.RoleTable roleTable;

    // The master role combination
    uint256 masterRole;



    constructor (uint8 _maximumRoleNumber, uint256 _masterRole) {
        roleTable.SetMaximumRoles (_maximumRoleNumber);
        masterRole = _masterRole;
        _setRole(msg.sender, masterRole);
    }

    modifier onlyRoleNumber (uint8 roleNumber) {
        require(roleTable.RoleExists(msg.sender, roleNumber), EldersRole.ERR_ACCOUNT_NOT_ALLOWED);
        _;
    }

    modifier onlyRole (uint256 role) {
        require(roleTable.GetRole(account) == role, EldersRole.ERR_ACCOUNT_NOT_ALLOWED);
        _;
    }

    function _addRole (address account, uint8 roleNumber) internal {
        roleTable.AddRole(account, roleNumber);
    }

    function _setRole (address account, uint256 role) internal {
        roleTable.SetRole(account, role);
    }

    function _getRole (address account) view internal returns (uint256) {
        return roleTable.GetRole(account);
    }

    function _setMaximumRoleNumber (uint8 roleNumber) internal {
        roleTable.SetMaximumRoles (roleNumber);
    }

    function _removeRole (address account, uint8 roleNumber) internal {
        roleTable.RemoveRole(account, roleNumber);
    }

    function _roleExists (address account, uint8 roleNumber) view internal returns (bool) {
        return roleTable.RoleExists(account, roleNumber);
    }

    function addRole (address account, uint8 roleNumber) public onlyRole(masterRole) {
        _addRole(account, roleNumber);
    }

    function getRole (address account) view public returns (uint256) {
        return _getRole(account);
    }

    function setRole (address account, uint256 role) public onlyRole(masterRole) {
        _setRole(account, role);
    }

    function setMaximumRoleNumber (uint8 roleNumber) public onlyRole(masterRole) {
        _setMaximumRoleNumber(roleNumber);
    }

    function removeRole (address account, uint8 roleNumber) public onlyRole(masterRole) {
        _removeRole(account, roleNumber);
    }

    function roleExists (address account, uint8 roleNumber) view public returns (bool) {
        _roleExists(account, roleNumber);
    }


}
