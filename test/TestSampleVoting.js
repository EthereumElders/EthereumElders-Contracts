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

// Testing frameworks
const TruffleAssert = require('truffle-assertions');
const Assert = require('chai');


const SampleVoting = artifacts.require('SampleVoting');

contract('SampleVoting', async (accounts) => {
    let contract;

    beforeEach(async () => {
        contract = await SampleVoting.new();
    });

    it('should be able to have a successful voting on 3 times', async () => {
        let tx = await contract.sampleVoteFunction.sendTransaction('param1','param2',{from: accounts[0]});
        TruffleAssert.eventNotEmitted(tx, 'SampleVote', () => {
            return false;
            },'should not emit an event');
        TruffleAssert.eventEmitted(tx, 'VoteCreated', () => {
                return true;
            },
            'should capture the block number nonce');
        tx = await contract.sampleVoteFunction.sendTransaction('param1', 'param2',{from: accounts[1]});
        TruffleAssert.eventNotEmitted(tx, 'SampleVote', () => {
            return false;
        },'should not emit an event');

        tx = await contract.sampleVoteFunction.sendTransaction('param1', 'param2',{from: accounts[2]});
        TruffleAssert.eventEmitted(tx, 'SampleVote', () => {
            return true;
        },'should emit an event');

        let operations = await contract.getOperations.call('SampleElectionTopic');
        assert.equal(operations.length, 0, 'ensure storage is cleaned up');
    });
});