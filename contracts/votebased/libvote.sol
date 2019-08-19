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
* Library for vote management for operations
*/
library EldersVote {
// Error statements
    string public constant ERR_CURRENT_VOTE_EXISTS = 'a current vote exists';
    string public constant ERR_EMPTY_VOTE = 'vote does not exist';


    // Structure for calculating votes for a specific operation, should not be used explicitly internal use only for
    // the library.
    struct VoteTable {
        // Addresses that already provided a vote
        address[] Voters;
        // Current votes
        uint256 Votes;
        // Required votes for operation to be executed
        uint256 VotesNeeded;
        // Index for reverse look up in the discovery
        uint256 Index;
    }

    // Operations table to track current votes, with vote discovery
    struct OperationsTable {
        // map to track votes
        mapping (string => VoteTable) Operation;
        // vote discovery array
        string[] PendingOperations;
    }

    function createVote(OperationsTable storage self, string voteSignature, uint256 votesNeeded) {
        require(self.Operation[voteSignature].Votes == 0 &&
            self.Operation[voteSignature].VotesNeeded == 0, ERR_CURRENT_VOTE_EXISTS);
        self.Operation[voteSignature] = VoteTable(
            {
                Voters: [msg.sender],
                Votes: uint256(0x01),
                VotesNeeded: votesNeeded,
                Index: OperationsTable.PendingOperations.length
            }
        );
        self.PendingOperations[OperationsTable.PendingOperations.length] = voteSignature;
    }

    function upVote(OperationsTable storage self, string voteSignature) internal {
        require(OperationsTable.Operation[voteSignature].Voters.length > 0, ERR_EMPTY_VOTE);
        self.Operation[voteSignature].Voters.push(msg.sender);
        self.Operation[voteSignature].Votes++;
    }

    function getVotes(OperationsTable storage self, string voteSignature) view internal returns (uint256) {
        return self.Operation[voteSignature].Votes;
    }

    function getVotesNeeded(OperationsTable storage self, string voteSignature) view internal returns (uint256) {
        return self.Operation[voteSignature].VotesNeeded;
    }

    function resetVote(OperationsTable storage self, string voteSignature) internal {
        require(self.Operation[voteSignature].Voters.length > 0, ERR_EMPTY_VOTE);
        // Fetch the last operation to replace the to be deleted operation
        self.PendingOperations[
            self.Operation[voteSignature].Index
        ] = self.PendingOperations[OperationsTable.PendingOperations.length];
        // Change the displaced operation index
        self.Operation[
            self.PendingOperations[OperationsTable.Operation[voteSignature].Index]
        ].Index = self.Operation[voteSignature].Index;
        // Delete the last element
        delete (self.PendingOperations[OperationsTable.PendingOperations.length]);
        // Delete the vote
        delete(self.Operation[voteSignature]);
    }
}
