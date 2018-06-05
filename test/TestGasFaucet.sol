pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/GasFaucet.sol";

contract TestGasFaucet {
    GasFaucet faucet = GasFaucet(DeployedAddresses.GasFaucet());

    // Calculate expected tokens is zero after deployment
    function testTokensReceivedIsZero() public {
        // Expected owner is this contract
        uint expected = 0;

        uint amount = faucet.calculateDispensedTokensForGasPrice(20);

        Assert.equal(amount, expected, "At launch calculated received tokens should be zero.");
    }

    // function testTokenBalanceIsZero() public {
    //     // Expected owner is this contract
    //     uint expected = 0;

    //     uint amount = faucet.calculateDispensedTokensForGasPrice(20);

    //     Assert.equal(amount, expected, "At launch calculated received tokens should be zero.");
    // }

    // // Testing owner setting dispense rate
    // function testOwnerSetRate() public {

    //     faucet.setSatoshiPerWei(1000);

    //     rate = faucet.getSatoshiPerWei();
    //     Assert.equal(rate, 1000, "Rate should have been changed to 1000.");
    // }
}