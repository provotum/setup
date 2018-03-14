#/bin/bash

# Declaring colors
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)

# List of sealers"
SEALERS="sealer01.provotum.ch
sealer02.provotum.ch
sealer03.provotum.ch
sealer04.provotum.ch
sealer05.provotum.ch"
SSH_KEY="~/.ssh/poa"

printf "${CYAN} Initializing genesis.json \n${NORMAL}"
for entry in $SEALERS; do
  osascript -e 'activate application "iTerm"
tell application "System Events" to keystroke "t" using command down
tell application "iTerm" to tell session -1 of current terminal to write text "ssh -i $SSH_KEY authority@$entry "tail -f ./provotum/node/console.log""'
done




