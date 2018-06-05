# GasFaucet

A erc-20 token faucet in a solidity contract. Functionality is very simple; 
a call to the dispense() function sends some of the stored tokens to the address
of the caller. In order to impose a cost on the tokens, the contract will
only send tokens proportional to the amount of gas spent. It is intended that
the Owner of the contract should adjust priceInWeiPerSatoshi periodically to
ensure that the monetary value of the tokens dispensed remains lower than the
value of the gas required.

### Requires
 - ganache [available here](http://truffleframework.com/ganache/)
 - truffle
   `npm install truffle -g`

### Testing
 1. Run Ganache
 2. Run `truffle test`