pragma solidity ^0.4.17;
/*

0xBitcoin Token Faucet in a Smart Contract (ver 0.0.0)

Any tokens sent to this contract may be withdrawn by other users through use
of the dispense() function. The dispensed amount is dependant on the
transaction's gas price. This means a transaction sent at 4 gwei will dispense
twice as many tokens as a transaction sent at 2 gwei.

The dispensing "rate" is changable by the contract owner and allows the rate to
be changed over time to follow the token's price. The intention of this ratio is
to ensure that the value of ether spent as gas is roughly equal to the value of
the tokens received.

Typically calls to dispense() cost about 41879 gas total. 

spentwei = gastotal * gasprice

spentusd = ethprice * spentwei/10**18

ideal0xbtc = spentusd / 0xbtcprice

ideal0xsatoshis = ideal0xbtc * 10**8


(weipriceusd) / (0xsatoshipriceusd)

(ethpriceusd/10**18) / (0xbtcpriceusd/10**8)

--> (ethpriceusd/10**10) * (1/0xbtcpriceusd)
--> (ethpriceusd/10**10) * (1/0xbtcpriceusd)

weipersatoshi = 


ethprice=500
0xbtcprice=1.2


priceratio = 

*/

pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./ERC20Interface.sol";
import "./Owned.sol";



contract GasFaucet is Owned {
    using SafeMath for uint256;

    address public faucetTokenAddress;
    uint256 public priceInWeiPerSatoshi;

    event Dispense(address indexed from, uint256 sendAmount);

    constructor() public {
        // 0xBitcoin Token Address (Ropsten)
        faucetTokenAddress = 0x9D2Cc383E677292ed87f63586086CfF62a009010;
        // 0xBitcoin Token Address (Mainnet)
        // faucetTokenAddress = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31;

        // Set rate to 0 satoshis / wei. Calls to 'dispense' will send 0 tokens
        // until the rate is manually changed.
        priceInWeiPerSatoshi = 0;
    }

    // ------------------------------------------------------------------------
    // Dispense some free tokens. The more gas you spend, the more tokens you
    // recieve. 
    // 
    // Tokens recieved (in satoshi) = gasprice / priceInWeiPerSatoshi
    // ------------------------------------------------------------------------
    function dispense() public {
        uint256 sendAmount = calculateDispensedTokensForGasPrice(tx.gasprice);
        require(tokenBalance() > sendAmount);

        ERC20Interface(faucetTokenAddress).transfer(msg.sender, sendAmount);

        emit Dispense(msg.sender, sendAmount);
    }
    
    // ------------------------------------------------------------------------
    // Retrieve the current dispensing rate in satoshis per gwei
    // ------------------------------------------------------------------------
    function calculateDispensedTokensForGasPrice(uint256 gasprice) public view returns (uint256) {
        if(priceInWeiPerSatoshi == 0){ 
            return 0; 
        }
        return gasprice.div(priceInWeiPerSatoshi);
    }
    
    // ------------------------------------------------------------------------
    // Retrieve Faucet's balance 
    // ------------------------------------------------------------------------
    function tokenBalance() public view returns (uint)  {
        return ERC20Interface(faucetTokenAddress).balanceOf(this);
    }
    
    // ------------------------------------------------------------------------
    // Retrieve the current dispensing rate in satoshis per gwei
    // ------------------------------------------------------------------------
    function getWeiPerSatoshi() public view returns (uint256) {
        return priceInWeiPerSatoshi;
    }
    
    // ------------------------------------------------------------------------
    // Set the current dispensing rate in satoshis per gwei
    // ------------------------------------------------------------------------
    function setWeiPerSatoshi(uint256 price) public onlyOwner {
        priceInWeiPerSatoshi = price;
    }

    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }

    // ------------------------------------------------------------------------
    // Owner can withdraw any accidentally sent eth
    // ------------------------------------------------------------------------
    function withdrawEth(uint256 amount) public {
        require(amount < address(this).balance);
        owner.transfer(amount);
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint256 tokens) public {
        
        // Note: Owner has full control of priceInWeiPerSatoshi, so preventing
        // withdrawal of the faucetTokenAddress token serves no purpose. It
        // would merely be misleading.
        //
        // if(tokenAddress == faucetTokenAddress){ 
        //     revert(); 
        // }

        ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}