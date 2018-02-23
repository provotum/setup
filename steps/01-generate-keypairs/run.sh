#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)

function run_npm_install_first() {
  	one=1;
    if [[ $1 -eq one ]]; then
		printf "${RED} %s\n Failed. Let's first run npm install. \n";
		printf "${GREEN} %s\n Running npm install. \n";
		(cd src; npm install > /dev/null);
		(node steps/01-generate-keypairs/src/generateKeys.js);		
    fi
}

# calling key generation with node
printf "${YELLOW} %s\n Generating keys using keythereum \n${NORMAL}"
output=$(node steps/01-generate-keypairs/src/generateKeys.js);

# if exitcode == 1, run npm install
exitcode=$?;
run_npm_install_first exitcode;

echo ${output} >> $(pwd)/logs/01-generate-keypairs.log;
echo "${output}";

printf "${NORMAL}"
