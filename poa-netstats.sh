#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
CYAN=$(tput setaf 6)
SSH_KEY="~/.ssh/poa"

SEALERS="sealer01.provotum.ch
sealer02.provotum.ch
sealer03.provotum.ch
sealer04.provotum.ch
sealer05.provotum.ch"

for entry in $SEALERS; do

SESSION_NAME=$(echo "$entry" | cut -d. -f1)

echo "$SESSION_NAME";
#tmux new -s $SESSION_NAME;
tmux new-session -d -s $SESSION_NAME 'ssh -i $SSH_KEY authority@$entry "sudo geth monitor --attach provotum/node/geth.ipc system/memory";'
tmux detach

printf "${GREEN} ✔ tmux session $entry started \n${NORMAL}"
done
