Setup
=====

This script generates all required preliminaries for a successful election.
The setup script is divided into multiple substeps, which are

1. Generate a new PoA genesis block holding a fixed amount of pre-allocated accounts. Further, the corresonding private keys are sent to the Mock Identity provider you should be running on port 8090.
2. Start a `poa-private-net` with 5 sealer nodes initializing with the previously generated genesis block. Also, `eth-net-intelligence-api` and `eth-netstats` is started to give an overview of the private network. 
3. Deploy the Proxy contract, which keeps track of the latest ballot contract. 


```bash
├── README.md
├── clean.sh #just deletes genesis.json and privatekeys.json
├── genesis.json # will be overwritten by steps/01-generate-keypairs every time ./setup is run
├── install.sh # inits & updates submodules and installs all npm projects
├── logs 
│   └── output.log # tail this
├── node_modules # contains relevant modules for step 01
├── package-lock.json
├── package.json
├── privatekeys.json  # will be overwritten by steps/01-generate-keypairs every time ./setup is run
├── resources # contains the submodules
│   ├── eth-contracts # smart contract submodule deploying proxy contract
│   └── poa-private-net # submodule containing a PoA 5 node private network
├── setup.sh # runs steps 01 - 03
├── steps
│   ├── 01-generate-keypairs 
│   ├── 02-start-eth-private-net
│   └── 03-setup-proxy-contract
└── teardown.sh # mainly tears down the private network & subsequently created / generated files and processes
```

# Prerequisites
The following requirements must be installed / executed 
before invoking `setup.sh`.

* As a starter, make sure you have the following things installed: `geth`, `go` and `npm`
* Install Truffle required for deploying contracts: `npm install -g truffle`

Next, run 
```bash
./install.sh
```
You may be prompted to enter your password.

# Invocation
Invoke the setup script from the root directory: 
```bash
./setup.sh
```
The most relevant output log can be tailed with `tail -f logs/output.log`.

# Shutting down
Invoke the teardown script from the root directory: 
```bash
./teardown.sh
```

