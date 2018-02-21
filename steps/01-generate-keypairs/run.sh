#!/usr/bin/env bash

GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)

printf "${YELLOW} %s\n Generating keys using keythereum \n \n"
printf "${GREEN}[01-generate-keypairs]${NORMAL}\n"

node generateKeys.js;