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

import "truffle/Assert.sol";
import {EldersRoleUtilities} from "../../contracts/rolebased/utils.sol";

pragma solidity ^0.5.1;

contract TestEldersRoleUtilities {

    function testRoleNumberToBytesConversions () public {
        Assert.equal(EldersRoleUtilities.RoleNumberToBytes(0x00), uint256(2**0), "should equal 1");
        Assert.equal(EldersRoleUtilities.RoleNumberToBytes(0x08), uint256(2**8), "should equal 2 to the power of 8");
        Assert.equal(EldersRoleUtilities.RoleNumberToBytes(0xFF), uint256(2**255), "should equal 2 to the power of 255");
    }

    function testAddRole () public {
        uint256 role = uint256(0x00);
        role = EldersRoleUtilities.AddToRole(role, 0x00);
        role = EldersRoleUtilities.AddToRole(role, 0x0F);
        role = EldersRoleUtilities.AddToRole(role, 0xFF);
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0x00), "should be true");
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0x0F), "should be true");
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0xFF), "should be true");
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0xF0), "should be false");
    }

    function testRemoveRole () public {
        uint256 role = ~ uint256(0x00);
        role = EldersRoleUtilities.RemoveFromRole(role, 0x00);
        role = EldersRoleUtilities.RemoveFromRole(role, 0x0F);
        role = EldersRoleUtilities.RemoveFromRole(role, 0xF0);
        role = EldersRoleUtilities.RemoveFromRole(role, 0xFF);
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0x00), "should be false");
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0x0F), "should be false");
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0xF0), "should be false");
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0xFF), "should be false");
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0xFA), "should be true");
    }

    function testRoleExists () public {
        uint256 role = uint256 (2**0 + 2**5 + 2**17 + 2**255);
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0x00), "should be true");
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0x05), "should be true");
        Assert.isTrue(EldersRoleUtilities.RoleExists(role, 0xFF), "should be true");
        Assert.isTrue(!EldersRoleUtilities.RoleExists(role, 0x02), "should be false");
    }
}
