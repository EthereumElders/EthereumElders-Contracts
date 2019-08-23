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
contract Electionable {

    using EldersVote for EldersVote.OperationsTable;

    event Vote(bytes32, uint256, uint256);
    event VoteCreated(string, bytes32);

    mapping(string => EldersVote.OperationsTable) private _elections;



    constructor() internal {
    }

    modifier Voted (string memory election, bytes32 voteSignature, uint256 votesNeeded) {
        require(votesNeeded > 1, 'needed votes must be more than one');
        if (_elections[election].getVotesNeeded(voteSignature) <= 1) {
            _elections[election].createVote(voteSignature, votesNeeded, msg.sender);
            emit VoteCreated(election, voteSignature);
        } else {
            _elections[election].upVote(voteSignature, msg.sender);
        }
        if (_elections[election].isSuccessful(voteSignature))
        {
            delete _elections[election];
            _;
        }
    }

    function isSuccessful (string memory election, bytes32 voteSignature) view public returns (bool) {
        return _elections[election].isSuccessful(voteSignature);
    }

    function hasVoted (string memory election, bytes32 voteSignature, address account) view public returns (bool) {
        return _elections[election].hasVoted(voteSignature, account);
    }

    function getVotes (string memory election,bytes32 voteSignature) view public returns (uint256) {
        return _elections[election].getVotes(voteSignature);
    }

    function getVotesNeeded (string memory election, bytes32 voteSignature) view public returns (uint256) {
        return _elections[election].getVotesNeeded(voteSignature);
    }

    function getOperations (string memory election) view public returns (bytes32 [] memory) {
        return _elections[election].getOperations();
    }

}
