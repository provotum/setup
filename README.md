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
* The [backend](https://github.com/provotum/backend) is running on `http://localhost:8080`.
* The [frontend](https://github.com/provotum/frontend) is running on `http://localhost:3000`.
* The [frontend-voter](https://github.com/provotum/frontend-voter) is running on `http://localhost:3001`.
* The `eth-netstats` will run on `http://localhost:3002` after ./setup sucessfully finished running.
* The [mock-identity-provider](https://github.com/provotum/mock-identity-provider) is running on PORT 8090.
* Install Truffle required for deploying contracts: `npm install -g truffle`

Next, run 
```bash
./install.sh
```
You may be prompted to enter your password.

# Invocation (local)
Invoke the setup script from the root directory: 
```bash
./setup.sh
```
The most relevant output log can be tailed with `tail -f logs/output.log`.

## Step 1
The parameters for the election can be easily configured by directly editing `.env`in the project root.
`NUMBER_OF_KEYS` defines the number of private keys that are generated and then distributed to the eligible voters by the mock identity provider. `MOCK_IDENTITY_PROVIDER` defines a hostname and port for the [mock-identity-provider](https://github.com/provotum/mock-identity-provider).
The rest of `.env` are parameters (*e.g.* GENESIS_CONFIG_*) for the genesis block that is generated for the private network. 
You should only change parameters if you know what you're doing. Else refer to [Genesis file explained](https://medium.com/taipei-ethereum-meetup/beginners-guide-to-ethereum-3-explain-the-genesis-file-and-use-it-to-customize-your-blockchain-552eb6265145). Be aware: `Puppeth` was used to generate the appropriate `extradata` in `genesis.json` and is currently hardcoded. 

In short, step 1:
* Generates `NUMBER_OF_KEYS` using [keythereum](https://github.com/ethereumjs/keythereum)
* Sucessfully sent plain private keys to http://localhost:8090/wallets (else fails with `exit 1`)
* Adds 5 nodes from poa-private-net to `genesis.json`
* Generating genesis block using params from `.env`


## Step 2
The second step starts the private network with 5 pre-configured sealer nodes which are located in resources/poa-private-net/. 

The main script is an adapted version of [`eth-private-net` by Vincent Chu](https://github.com/vincentchu/eth-private-net)
The nodes are initialized with the previously generated genesis block. Then, the geth nodes are started with the parameters defined in `poa-private-net` on the RPC ports `8501`, `8502`, `8503`, `8504`,`8505`. 
If `pm2` has been sucessfully installed and `npm install` & `grunt all` were sucessful, pm2 is started using provotum.json, pre-defining the 5 nodes. If you want to change anything in the 5 node setup, you need to regenerate the `.json` accordingly and also use puppeth to generate valid extradata. 
After that, `eth-netstats` is started on `http://localhost:3002` and should display 5 functioning nodes. 

In short, step 2:
* Initialize and start 5 sealer geth nodes with previously generated `genesis.json`
* Start communication from nodes to dashboard and display dashboard


## Step 3
//TODO 

# Shutting down
Invoke the teardown script from the root directory: 
```bash
./teardown.sh
```


