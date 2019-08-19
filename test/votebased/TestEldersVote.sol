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
        Table.createVote(string('vote1signature'), uint256(0x05) ,address (0x00));
        Assert.equal(Table.getVotes('vote1signature'), 0x1, 'must equal to initial voting value one');
        Assert.equal(Table.getVotesNeeded('vote1signature'), 0x05, 'must equal to 5 needed votes');
        Assert.equal(Table.getOperations().length, 0x01, 'must be one item in the discovery');
        Assert.equal(Table.getOperations()[0], string ('vote1signature'), 'must match the unique key string');
    }

    function testUpVote() public {
        Table.createVote(string('vote1'), uint(0x05), address (0x01));
        Table.upVote(string('vote1'), address (0x00));
        Assert.equal(Table.getVotes('vote1'), 0x02, 'must equal to two votes');
    }

    function testNoVoteForOperation () public {
        Assert.equal(Table.getVotes('novote'), 0x00, 'must be zero to ensure no vote existing');
    }


}
