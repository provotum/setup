#!/bin/bash
SEALERS="sealer01.provotum.ch
sealer02.provotum.ch
sealer03.provotum.ch
sealer04.provotum.ch
sealer05.provotum.ch"

SSH_KEY="~/.ssh/poa"
NORMAL=$(tput sgr0)
CYAN=$(tput setaf 6)


for entry in $SEALERS; do
  printf "${CYAN}Executing $1 on $entry\n${NORMAL}"
  ssh -i $SSH_KEY authority@$entry $1;
done