 var Contract = artifacts.require('EldersLogicManag');

 contract("EldersLogicManagTest", function(accounts) {
    var contractInstance;
    var eldersAddresses = [
        accounts[1],
        accounts[2],
    ];

    beforeEach("Setup new instance for each test case", async() =>{
        contractInstance = await Contract.new(eldersAddresses, 20, {from: accounts[0]});
    })

    it("Check if contract has an owner", async() => {
        // Assert that the contractInstance.owner() is the same owner
        // i passed in the contract parameters
        assert.equal(await contractInstance.owner(), accounts[0])
    });

    it("Should not allow a user to add new logic to new contract whom is not owner", async () => {
        let result = await contractInstance.AddNewLogicContract();
    });

 });