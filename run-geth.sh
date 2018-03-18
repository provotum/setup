#!/bin/bash

touch /home/authority/provotum/node/console.log;
geth --datadir=/home/authority/provotum/node/ --syncmode "full" --identity=$1 --port=30300 --rpc --rpccorsdomain=* --rpcapi admin,debug,net,clique,eth,web3,miner,personal --rpcport=8500 --networkid=187 --preload=/home/authority/provotum/identities.js --bootnodes enode://a349b003327c3075b779715a733d5076b986aae0225c48a760cd2b0e768b9654c0179014353ebb34eb0b9e7654caf69ec56d80b1b32705277bad953fb7777585@10.135.29.232:30301 --nodiscover --metrics --verbosity=6 --unlock 0 --password /home/authority/provotum/password.sec --nat "extip:$2">> /home/authority/provotum/node/console.log 2>&1 &