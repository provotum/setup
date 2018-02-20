#!/usr/bin/env bash

function abort_if_geth_not_connected() {
    # $1 is the first argument passed to this function
    if [[ $1 = *"Could not connect to your Ethereum client"* ]]; then
        echo "";
        echo "[ERROR] Failed to connect to Geth node. Error output below:";
        echo ${1};
        exit 1;
    fi
}


printf "Initializing smart contracts...\n"

# Compiling Contracts and initially deploying the Proxy contract.
cd $(pwd)/resources/eth-contracts;

echo "Compiling contracts... ";
output="$(truffle compile)";
echo ${output} >> $(pwd)/../../logs/output.log;

abort_if_geth_not_connected "${output}"

echo "Migrating (deploying) contracts... ";

output="$(truffle migrate)";
echo ${output} >> $(pwd)/../../logs/output.log;

abort_if_geth_not_connected "${output}"

cd $(pwd)/../..;
