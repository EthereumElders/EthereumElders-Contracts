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

import {EldersVote} from "./EldersVote.sol";

/**
* Ethereum Elders votable smart contract instance
* provides a seamless voting mechanism through explicit usage of
* abi pack encoding with hashing and a nonce
* nonce is zero, when it's intended to create a vote
*/
contract Voteable {

    using EldersVote for EldersVote.OperationsTable;

    event Vote(bytes32, uint256, uint256);
    event VoteCreated(uint256, bytes32);

    EldersVote.OperationsTable private _operationsTable;



    constructor() internal {
    }

    modifier Voted (uint256 nonce, bytes32 voteSignature, uint256 votesNeeded) {
        bytes32 key;
        if (nonce == 0) {
            key = bytes32(block.number + uint256(voteSignature));
            _operationsTable.createVote(key, votesNeeded, msg.sender);
            emit VoteCreated(block.number, key);
        } else {
            key = bytes32(nonce + uint256(voteSignature));
            _operationsTable.upVote(key, msg.sender);
        }
        if (_operationsTable.isSuccessful(key))
        {
            _;
        }
    }

    function isSuccessful (bytes32 voteSignature) view public returns (bool) {
        return _operationsTable.isSuccessful(voteSignature);
    }

    function hasVoted (bytes32 voteSignature, address account) view public returns (bool) {
        return _operationsTable.hasVoted(voteSignature, account);
    }

    function getVotes (bytes32 voteSignature) view public returns (uint256) {
        return _operationsTable.getVotes(voteSignature);
    }

    function getVotesNeeded (bytes32 voteSignature) view public returns (uint256) {
        return _operationsTable.getVotesNeeded(voteSignature);
    }

    function getOperations () view public returns (bytes32 [] memory) {
        return _operationsTable.getOperations();
    }

}
