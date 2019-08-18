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

import "truffle/Assert.sol";
import {EldersRole} from "../../contracts/rolebased/librole.sol";

contract TestLibEldersRole {
    using EldersRole for EldersRole.RoleTable;
    EldersRole.RoleTable Table;

    function testAddRole () public {
        Table.SetMaximumRoles(0x2);
        Table.AddRole(address (0x00), 0x1);
        Table.AddRole(address (0x01), 0x1);
        Assert.isTrue(Table.RoleExists(address(0x00), 0x01), "Role should exist");
        Assert.isTrue(Table.RoleExists(address(0x01), 0x01), "Role should exist");
    }

    function testSetRole () public {
        Table.SetMaximumRoles(0x2);
        Table.SetRole(address(0x00), 0x01);
        Table.SetRole(address(0x01), 0x01);
        Assert.isTrue(Table.RoleExists(address(0x00), 0x00), "Role should exist");
        Assert.isTrue(Table.RoleExists(address(0x01), 0x00), "Role should exist");
    }

    function testRemoveRole () public {
        Table.SetMaximumRoles(0x3);
        Table.SetRole(address(0x00), 0x03);
        Table.SetRole(address(0x01), 0x07);
        Table.RemoveRole(address(0x00), 0x00);
        Table.RemoveRole(address(0x01), 0x03);
        Assert.isTrue(!Table.RoleExists(address(0x00), 0x00), "Role should not exist");
        Assert.isTrue(!Table.RoleExists(address(0x01), 0x03), "Role should not exist");
        Assert.isTrue(Table.RoleExists(address(0x01), 0x00), "Role should exist");
    }

//    NOTE: Unable to test the maximum role assertion in solidity, because no catch mechanism, an overall behaviour test
//    in javascript should cover this part
}
