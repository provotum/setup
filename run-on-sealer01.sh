#/bin/bash
SEALERS="sealer01.provotum.ch"

SSH_KEY="~/.ssh/poa"

for entry in $SEALERS; do
  ssh -i $SSH_KEY authority@$entry $1;
done