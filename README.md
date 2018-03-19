## Important Note & Disclaimer

- The **[master branch](https://github.com/provotum/setup/tree/master) contains the setup code for a local deployment on your machine**.
- The **remote branch (you're here) contains setup code for a remote deployment on different servers; replace IP's and domain names accordingly.** 
- **The code in this repository is highly experimental. Do not use it for anything security-critical. All usage at your own risk.**

## Setup (**remote**)

This repository generates all required preliminaries for a successful election for you to run on a cloud or other remote server environment. The `./setup.sh` script basically invokes all the steps in `steps` (*e.g.* You could add a new folder `02-deploy-contracts` with a `run.sh` that deploys some contracts with truffle)

However, the script in 

1. Generate a new genesis block holding a fixed amount of pre-allocated accounts. Further, the corresonding private keys are sent to the Mock Identity provider you should be running on the ip you defined in `.env`.
2. Start a `poa-private-net` with 5 nodes in total (2 are authorized to seal) initializing with the previously generated genesis block. There are different helper scripts available. If you want to montitor the behaviour of youre network, you can use the `provotum.yml` file with tmuxinator and it will give you a good overview over logs and performance.


```bash

.
├── .env # check this file to configure ./steps/01-deploy-poa-net/src/generateKeys.js
├── README.md
├── attach-nodes.sh # this script first gets all enode info from each node and then attaches all nodes to each other
├── boot.key # this will be scp'd to node 1 since it's necessary to run the bootnode
├── exec-on-sealers.sh # ./exec-on-sealers.sh 'ls' will execute ls on all servers using ssh and return results
├── identities.js # contains all the identities for geth to preload them and easily assign
├── install.sh # just some more convenient initializing and installing of submodules and the npm project for key generation
├── logs 
├── package-lock.json
├── package.json
├── provotum.yaml # use tmuxinator to have a nice tmux session with 4 nodes geth logs / geth metrics
├── resources 
│   └── poa-private-net
├── run-geth-with-mine.sh # will be scp'd to nodes 1 and 2 && will be run on the authorized nodes 1 and 2
├── run-geth.sh # will be scp'd to nodes 3 - 5 and will be run on the nodes 3 - 5 
├── setup.sh # main script, run this after ./install.sh to execute the setup
├── start-bootnode.sh # script will be copied to node 1 and executed there since it's the bootnode
└── steps
    └── 01-deploy-poa-net
        ├── run.sh # this will be invoked by ./setup and contains the main script relevant for remote deployment
        └── src
            ├── generateKeys.js # generates the private keys for votes, exports them and creates a genesis block pre-allocating those voter accounts
            └── password.sec # eth.coinbase password for all nodes
```
# Prerequisites

The following requirements must be installed / executed before invoking `setup.sh`.
**Instead of using a placeholder domain, we use `provotum.ch`; where ever necessary replace with your domain.** 

* As a starter, make sure you have the following things installed: `geth`, `go` and `npm`
* The [backend](https://github.com/provotum/backend) is running on `https://backend.provotum.ch:8080`
* The [admin](https://github.com/provotum/admin) frontend is running on `https://admin.provotum.ch:3000`
* The [frontend](https://github.com/provotum/frontend) is running on `https://vote.provotum.ch:3001`
* The [mock-identity-provider](https://github.com/provotum/mock-identity-provider) is running on `https://id.provotum.ch:8090`

First of all, run 
```bash
./install.sh
```
You may be prompted to enter your password.

# Invocation (local)
Invoke the setup script from the root directory: 
```bash
./setup.sh
```

## `steps/01-deploy-poa-net/run.sh`

This bash script executes every step in order to sucessfully start a proof-of-authority private network. 
The sealer servers all have `geth 1.7.3 stable` installed and are `8 GB Memory / 25 GB Disk / Ubuntu 16.04.4 x64`. 
Make sure you `sudo ufw allow $PORT` for your geth instances.
Watch out `.env` is only used in the first step, where genesis.json and `privatekeys.json` is generated, the bash file `./steps/01-deploy-poa-net/run.sh` has all configuration at the top of the file; which then executes: 
* Execute `node src/generateKeys.js` to generate `NUMBER_OF_KEYS` >> `privatekeys.json` and pre-alloc in `genesis.json`
* Sendd `privatekeys.json` to `MOCK_IDENTITY_PROVIDER`
* Kill all running geth / bootnode instances on nodes
* Remove old files (chaindata, genesis.json)
* SCP newly generated `genesis.json` and `boot.key` nodes
* Initialize `genesis.json` on all nodes and start `bootnode` on node 1
* Slowly start `run-get-with-mine.sh` on node 1 and 2
* Start `run-geth.sh` on node 3 to 5
* Now ssh to your node and tail -f `provotum/node/console.log`

The script needs a lot of customization to work on your specific environment. 
Feel free to contact us for support. 
