Setup
=====

This script generates all required preliminaries 
for a successful election.

The setup script performs the following steps:

1. Generate a new genesis block holding a fixed amount of pre-allocated wallets.
2. Start the geth node using the previously generated genesis block.
3. Deploy the Proxy contract, which keeps track of the latest ballot contract. 


# Requirements
The following requirements must be installed / executed 
before invoking `setup.sh`.

* Run `git submodule init && git submodule update` to get the required smart contracts.
* Install Truffle required for deploying contracts: `npm install -g truffle`
* Adjust `resources/eth-contracts/truffle.js` to match your networks setup
* Start your Ethereum node, e.g. `geth --rpcapi personal,db,eth,net,web3 --rpc --testnet --syncmode "full" --verbosity=3 --rpccorsdomain "*"`
* Unlock your coinbase account, which will be used to deploy the contracts: `web3.personal.unlockAccount(web3.personal.listAccounts[0], 'your password')`

# Invocation
Invoke the setup script from the root directory: `./setup.sh`.
You may tail on the output log by `tail -f logs/output.log`.
