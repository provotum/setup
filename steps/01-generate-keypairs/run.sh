#!/usr/bin/env bash

GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)

printf "${YELLOW} %s\n Generating keys using keythereum \n \n"

node steps/01-generate-keypairs/src/generateKeys.js;

printf "${NORMAL}"
