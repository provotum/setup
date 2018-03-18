#!/bin/bash

function exec_via_ssh() {
    ssh -i $SSH_KEY authority@$1 "$2";
}

SSH_KEY="~/.ssh/poa"

ENODES_INT[0]="@10.135.29.232:30300?discport=0"
ENODES_INT[1]="@10.135.96.13:30300?discport=0"
ENODES_INT[2]="@10.135.95.191:30300?discport=0"
ENODES_INT[3]="@10.135.48.37:30300?discport=0"
ENODES_INT[4]="@10.135.75.26:30300?discport=0"

SEALER_NODES_ARR[0]="sealer01.provotum.ch"
SEALER_NODES_ARR[1]="sealer02.provotum.ch"
SEALER_NODES_ARR[2]="sealer03.provotum.ch"
SEALER_NODES_ARR[3]="sealer04.provotum.ch"
SEALER_NODES_ARR[4]="sealer05.provotum.ch"

SEALER_NODES="sealer01.provotum.ch
sealer02.provotum.ch
sealer03.provotum.ch
sealer04.provotum.ch
sealer05.provotum.ch"

enodes=()
ENODE_CUT=()
enode_final=()

for entry in $SEALER_NODES; do
  curr_enode=$(exec_via_ssh $entry "geth --exec="admin.nodeInfo.enode" attach /home/authority/provotum/node/geth.ipc")
  enodes+=("$curr_enode")
  printf '%s\n' "FULL ARRAY (enodes):" "${enodes[@]}"
done

for((i=0;i<5;i++));do
  ENODE_CUT[$i]=$(echo "${enodes[$i]//@*0/${ENODES_INT[$i]}}")
done
printf '%s\n' "FULL ARRAY (enode_cut):" "${enode_cut[@]}"


for((i=0;i<5;i++));do
	for((j=0;j<5;j++));do
		echo ${SEALER_NODES_ARR[$i]}
		echo ${ENODE_CUT[$j]}
		
		cmd_middle="${ENODE_CUT[$j]}"
		cmd_begin="'admin.addPeer("
		cmd_end=")'"
		final_cmd="$cmd_begin$cmd_middle$cmd_end"
		echo $final_cmd

    	if [[ $i -ne $j ]]; then
	        cmd="geth --exec=${final_cmd} attach /home/authority/provotum/node/geth.ipc"
			echo $cmd;
	    	ssh -i $SSH_KEY authority@${SEALER_NODES_ARR[$i]} $cmd;
    	fi
	done
done



