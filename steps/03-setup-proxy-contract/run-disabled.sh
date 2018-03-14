#!/usr/bin/env bash

GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

function abort_if_geth_not_connected() {
    # $1 is the first argument passed to this function
    if [[ $1 = *"Could not connect to your Ethereum client"* ]]; then
        echo "";
        echo "[ERROR] Failed to connect to Geth node. Have you started geth? If so, check truffle.js for the network configuration. Error output below:";
        echo "";
        echo ${1};
        exit 1;
    fi

    # $1 is the first argument passed to this function
    if [[ $1 = *"Error: authentication needed: password or unlock"* ]]; then
        echo "";
        echo "[ERROR] You must unlock the Coinbase before you can deploy: web3.personal.unlockAccount(web3.personal.listAccounts[0], 'password'). Error below:";
        echo "";
        echo ${1};
        exit 1;
    fi
}


printf "Initializing smart contracts...\n"

# Compiling Contracts and initially deploying the Proxy contract.
cd $(pwd)/resources/eth-contracts;

# Removing previously built contracts
rm build/contracts/*

echo "Compiling contracts... ";
output="$(truffle compile)";
echo ${output} >> $(pwd)/../../logs/output.log;

abort_if_geth_not_connected "${output}"

echo "Migrating (deploying) contracts. This may take a few minutes... ";

output="$(truffle migrate --network provotum)";
echo ${output} >> $(pwd)/../../logs/output.log;

abort_if_geth_not_connected "${output}"

# Echo the proxy contracts transaction
regex=".*Proxy contract is deployed at ([a-zA-Z0-9]+).*"
if [[ ${output} =~ $regex ]]; then
    address="${BASH_REMATCH[1]}"
    echo "${GREEN}[Done]${NORMAL} Deployed proxy contract at ${address}."
else
    echo "Failed to deploy proxy contract. See the logs in /logs/output.log for more details."
    exit 1;
fi


cd $(pwd)/../..;
