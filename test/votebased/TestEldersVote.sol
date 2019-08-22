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
import {EldersVote} from "../../contracts/votebased/EldersVote.sol";

contract TestEldersVote {
    using EldersVote for EldersVote.OperationsTable;
    EldersVote.OperationsTable Table;

    function testCreateVote() public {
        Table.CreateVote(bytes32("vote1signature"), uint256(0x05) ,address (0x00));
        Assert.equal(Table.GetVotes(bytes32("vote1signature")), 0x1, "must equal to initial voting value one");
        Assert.equal(Table.GetVotesNeeded(bytes32("vote1signature")), 0x05, "must equal to 5 needed votes");
        Assert.equal(Table.GetOperations().length, 0x01, "must be one item in the discovery");
        Assert.equal(Table.GetOperations()[0], bytes32("vote1signature"), "must match the unique key string");
    }

    function testUpVote() public {
        Table.CreateVote(bytes32("vote1"), uint(0x05), address (0x01));
        Table.UpVote(bytes32("vote1"), address (0x00));
        Assert.equal(Table.GetVotes(bytes32("vote1")), 0x02, "must equal to two votes");
    }

    function testHasVoted() public {
        Table.CreateVote(bytes32("vote2"), uint(0x02), address (0x01));
        Assert.isTrue(Table.HasVoted(bytes32("vote2"), address (0x01)), "must be true for address 0x01");
        Assert.isTrue(!Table.HasVoted(bytes32("vote2"), address (0x02)), "must be false for address 0x02");
    }

    function testIsSuccessful() public {
        Table.CreateVote(bytes32 ("vote3"), uint (0x02), address (0x01));
        Assert.isTrue(!Table.IsSuccessful(bytes32("vote3")), "must be false");
        Table.UpVote(bytes32 ("vote3"), address (0x02));
        Assert.isTrue(Table.IsSuccessful("vote3"), "must be true");
    }

    function testNoVoteForOperation () public {
        Assert.equal(Table.GetVotes(bytes32("novote")), 0x00, "must be zero to ensure no vote existing");
    }


}
