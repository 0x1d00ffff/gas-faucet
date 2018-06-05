const GasFaucet = artifacts.require("GasFaucet");

contract('Test main GasFaucet operations', async (accounts) => {

  // it("should have zero tokens available at launch", async () => {
  //   let instance = await GasFaucet.deployed();
  //   let balance = await instance.tokenBalance.call();
  //   assert.equal(balance.valueOf(), 0);
  // })

  it("should allow only owner to change token rate", async () => {
    let instance = await GasFaucet.deployed();

    let owner = accounts[0];
    let other_user = accounts[1];

    // owner should be able to set rate to 1000
    await instance.setWeiPerSatoshi(1000, {from: owner});
    let rate = await instance.getWeiPerSatoshi.call();
    assert.equal(rate.valueOf(), 1000);

    // anyone else cannot change rate
    try {
      await instance.setWeiPerSatoshi(2000, {from: other_user});
    }
    catch(e) {
      // do nothing
    }
    
    // value is unchanged
    assert.equal(rate.valueOf(), 1000);
  });

  it("should calculate correct token dispensing amount", async () => {
    let instance = await GasFaucet.deployed();

    let owner = accounts[0];
    await instance.setWeiPerSatoshi(1000, {from: owner});

    let amount = await instance.calculateDispensedTokensForGasPrice.call(50000);

    assert.equal(amount.valueOf(), 50000/1000);
  });

  // it("can't send eth to contract", async () => {
  //   let instance = await GasFaucet.deployed();

  //   let owner = accounts[0];
  //   let other_user = accounts[1];

  //   let balance_before = await instance.balance;

  //   // attempt to send eth to contract
  //   try {
  //     instance.sendTransaction({from:owner, value:1000})
  //     .then(function(result) {
  //       // do nothing
  //     })
  //     .err(function(err) {
  //       // do nothing
  //     });
  //   }
  //   catch(e) {
  //     // do nothing
  //   }

  //   let balance_after = await owner.balance;

  //   assert.equal(balance_before, balance_after);
  // });

  // it("should send coin correctly", async () => {

  //   // Get initial balances of first and second account.
  //   let account_one = accounts[0];
  //   let account_two = accounts[1];

  //   let amount = 10;


  //   let instance = await GasFaucet.deployed();
  //   let meta = instance;

  //   let balance = await meta.getBalance.call(account_one);
  //   let account_one_starting_balance = balance.toNumber();

  //   balance = await meta.getBalance.call(account_two);
  //   let account_two_starting_balance = balance.toNumber();
  //   await meta.sendCoin(account_two, amount, {from: account_one});

  //   balance = await meta.getBalance.call(account_one);
  //   let account_one_ending_balance = balance.toNumber();

  //   balance = await meta.getBalance.call(account_two);
  //   let account_two_ending_balance = balance.toNumber();

  //   assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
  //   assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
  // });

})