#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
CYAN=$(tput setaf 6)

# Clean up before starting
rm -rf $(pwd)/genesis.json;
rm -rf $(pwd)/privatekeys.json;

# calling key generation with node
printf "${CYAN}Generating keys using keythereum \n${NORMAL}"
output=$(node steps/01-generate-keypairs/src/generateKeys.js);
status=$?;

echo ${output} >> $(pwd)/logs/output.log;
echo "${output}";

    if [[ ${status} -ne "0" ]]; then
        exit ${status};
    fi
  
printf "${NORMAL}"
