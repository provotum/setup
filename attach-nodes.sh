#/bin/bash

function exec_on_node() {
  geth --exec="$1" attach /home/authority/provotum/node/geth.ipc
}

function exec_via_ssh() {
    ssh -i $SSH_KEY authority@$1 "$2";
}

#geth --exec="admin.addPeer(\"enode://831910e61f2ab435c9de02581e412ba95524a9e49fbfd534205aee05c990e17f2aa84cd95562f6113906efa215f1da577f270cf9628d01746c354f094438776d@10.135.29.232:30300?discport=0\")" attach /home/authority/provotum/node/geth.ipc

SSH_KEY="~/.ssh/poa"

ENODES_INT[0]="@10.135.29.232:30300?discport=0"
ENODES_INT[1]="@10.135.96.13:30300?discport=0"
ENODES_INT[2]="@10.135.95.191:30300?discport=0"
ENODES_INT[3]="@10.135.48.37:30300?discport=0"
ENODES_INT[4]="@10.135.75.26:30300?discport=0"
#ORDER IS RELEVANT!!

#ENODES_EXT[0]="@46.101.98.114:30300?discport=0"
#ENODES_EXT[1]="@138.197.176.96:30300?discport=0"
#ENODES_EXT[2]="@159.65.116.125:30300?discport=0"
#ENODES_EXT[3]="@138.68.89.116:30300?discport=0"
#ENODES_EXT[4]="@138.68.86.102:30300?discport=0"

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
  # Collect all admin.nodeInfo.enode in an array
  curr_enode=$(exec_via_ssh $entry "geth --exec="admin.nodeInfo.enode" attach /home/authority/provotum/node/geth.ipc")
  enodes+=("$curr_enode")
  printf '%s\n' "FULL ARRAY (enodes):" "${enodes[@]}"
done

# CUT OUT ENODE STRING
#for entry in $enodes; do
for((i=0;i<5;i++));do
  #echo ${#enodes[@]}
  # create for loop that iterates through ENODE and creates new cut string
  #curr_enode_string=$(entry)
  #echo $i
  #printf '%s\n' "CURRENT PRE CUT ENODE STRING:" "${enodes[$i]}"
    #ip=$( echo "$line" |cut -d\: -f1 )


  #$ var="She favors the bold.  That's cold."
  #$ echo "${var//b??d/mold}"
  #echo "BEGIN ECHO TEST"
  #echo_var=${enodes_internal[$i]}
  #echo "${enodes[$i]//@*0/$echo_var}"
  #echo "${enodes[$i]//@*0/${ENODES_INTERNAL[$i]}}"
  #echo "END ECHO TEST"
  #cut_enode_string=$(echo "$str" | cut -f 1 -d'@')
  #cut_enode_string=$(echo "$enodes[$i]" | cut -f 1 -d'@')
  # doesnt assign variable correctly  
  #printf '%s\n' "CURRENT POST CUT ENODE STRING:" "${cut_enode_string}"
  #"cut apart from @[::]:30300?discport=0"
  #enode_cut+=("$cut_enode_string")
  ENODE_CUT[$i]=$(echo "${enodes[$i]//@*0/${ENODES_INT[$i]}}")


  #unset cut_enode_string
  #printf '%s\n' "FULL ARRAY (enodes):" "${enodes[@]}"
  # needs another for loop that attaches @INTERNAL_IP:30300?discport=0
  #enode_final+=
  # append IP
  # then, loop through sealer nodes again to add all the ENODES that were collected and prepared.
  # then, check net.peerCount
done

printf '%s\n' "FULL ARRAY (enode_cut):" "${enode_cut[@]}"


# Iterate through Sealer Nodes and add 
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
		
	    #ssh -i $SSH_KEY authority@${SEALER_NODES_ARR[$i]} "geth --exec=\"admin.addPeer\(\"${enode_cut[$i]}\"\)\" attach /home/authority/provotum/node/geth.ipc";
		#curr_enode=$(exec_via_ssh ${SEALER_NODES[$i]} "geth --exec="admin.addPeer\(${enode_cut[$i]}\)" attach /home/authority/provotum/node/geth.ipc")
	done	
done


#echo ${#enode_cut[@]}
#enode_cut_len=$(echo $({#enode_cut[@]})
	#${#ArrayName[@]}

	#for ((i=0; i<${enode_cut_len}; i++)); do
    #	echo $i
	#done
 
  
  


  # the command that needs to be returned: geth --exec="admin.nodeInfo.enode" attach /home/authority/provotum/node/geth.ipc
  # then we need to add the IP into the string... 

  #CONNECT_JS="admin.addPeer(\"$entry\")"
  #exec_on_node $CONNECT_JS


#connect)
#    IDENTITY1=$2
#    IDENTITY2=$3

    #ENODE=$(exec_on_node $IDENTITY1 'admin.nodeInfo.enode')
    #CONNECT_JS="admin.addPeer($ENODE)"

    #exec_on_node $IDENTITY2 $CONNECT_JS
    #;;


