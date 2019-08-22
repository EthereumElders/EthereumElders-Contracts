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
* Operations are designated by unique string signatures that should be handled by the library user
*/
library EldersVote {
// Error statements
    string public constant ERR_CURRENT_VOTE_EXISTS = 'a current vote exists';
    string public constant ERR_EMPTY_VOTE = 'vote does not exist';
    string public constant ERR_ALREADY_VOTED = 'address already voted';
    string public constant ERR_VOTES_MORE_THAN_ONE = 'votes need to be more than one';
    string public constant ERR_VOTE_IS_OVER = 'votes needed reached';

    // Structure for calculating votes for a specific operation, should not be used explicitly internal use only for
    // the library.
    struct VoteTable {
        // Addresses that already provided a vote
        mapping (address => bool) Voters;
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
        mapping (bytes32 => VoteTable) Operation;
        // vote discovery array
        bytes32[] Operations;
    }

    // Events for operations vote
    event Vote (bytes32, uint256, uint256);

    /**
    * Create a new vote for a given signature with required needed votes
    * @param voteSignature string - the unique string signature for operation key
    * @param votesNeeded uint256 - the number of required votes for this operation
    * @param account address - the address of the account creating the vote
    */
    function CreateVote(OperationsTable storage self, bytes32 voteSignature, uint256 votesNeeded,
        address account ) internal {
        require(self.Operation[voteSignature].Votes == 0 &&
            self.Operation[voteSignature].VotesNeeded == 0, ERR_CURRENT_VOTE_EXISTS);
        require(votesNeeded > 0x01, ERR_VOTES_MORE_THAN_ONE);
        self.Operation[voteSignature].Votes = 0x01;
        self.Operation[voteSignature].VotesNeeded = votesNeeded;
        self.Operation[voteSignature].Voters[account] = true;
        self.Operation[voteSignature].Index = self.Operations.length;
        self.Operations.push(voteSignature);
        emit Vote(voteSignature, uint256(0x01) , votesNeeded);
    }

    /**
    * Upvotes a pending operation
    * @param voteSignature string - the unique string signature for operation key
    */
    function UpVote(OperationsTable storage self, bytes32 voteSignature, address account) internal {
        require(self.Operation[voteSignature].Votes > 0, ERR_EMPTY_VOTE);
        require(self.Operation[voteSignature].Voters[account] == false, ERR_ALREADY_VOTED);
        require(self.Operation[voteSignature].VotesNeeded >= self.Operation[voteSignature].Votes, ERR_VOTE_IS_OVER);
        self.Operation[voteSignature].Voters[account] = true;
        self.Operation[voteSignature].Votes++;
        emit Vote(voteSignature, self.Operation[voteSignature].Votes, self.Operation[voteSignature].VotesNeeded);
    }

    function IsSuccessful(OperationsTable storage self, bytes32 voteSignature) view internal returns (bool) {
        return self.Operation[voteSignature].Votes >= self.Operation[voteSignature].VotesNeeded;
    }

    /**
    * Returns current voters addresses for a given operation
    * @param voteSignature string - the unique string signature for operation key
    * @param account address - the address to check if voted
    */
    function HasVoted(OperationsTable storage self, bytes32 voteSignature, address account) view internal
        returns (bool) {
        return self.Operation[voteSignature].Voters[account];
    }

    /**
    * Returns current vote count for a given operation
    * @param voteSignature string - the unique string signature for operation key
    */
    function GetVotes(OperationsTable storage self, bytes32 voteSignature) view internal returns (uint256) {
        return self.Operation[voteSignature].Votes;
    }

    /**
    * Returns the votes needed for a given operation
    * @param voteSignature string - the unique string signature for operation key
    */
    function GetVotesNeeded(OperationsTable storage self, bytes32 voteSignature) view internal returns (uint256) {
        return self.Operation[voteSignature].VotesNeeded;
    }

    /**
    * Returns the current operations
    */
    function GetOperations(OperationsTable storage self) view internal returns ( bytes32 [] memory ) {
        return self.Operations;
    }
}
