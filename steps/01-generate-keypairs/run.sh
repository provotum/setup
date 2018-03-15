#!/usr/bin/env bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
CYAN=$(tput setaf 6)

IDENTITIES=(sealer01 sealer02 sealer03 sealer04 sealer05)
FLAGS='--networkid=187 --preload=./provotum/identities.js'
DEV_FLAGS='--bootnodes 'enode://a349b003327c3075b779715a733d5076b986aae0225c48a760cd2b0e768b9654c0179014353ebb34eb0b9e7654caf69ec56d80b1b32705277bad953fb7777585@10.135.29.232:30310' --nodiscover --verbosity=4 --unlock 0 --password ./provotum/password.sec --mine --nat=none'
BASE_PORT=30300
BASE_RPC_PORT=8500
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)

# List of sealers"
SEALERS="sealer01.provotum.ch
sealer02.provotum.ch
sealer03.provotum.ch
sealer04.provotum.ch
sealer05.provotum.ch"

#EXT_IP[0]="46.101.98.114"
#EXT_IP[1]="138.197.176.96"
#EXT_IP[2]="159.65.116.125"
#EXT_IP[3]="138.68.89.116"
#EXT_IP[4]="138.68.86.102"	

INT_IP[0]="10.135.29.232"
INT_IP[1]="10.135.96.13"
INT_IP[2]="10.135.95.191"
INT_IP[3]="10.135.48.37"
INT_IP[4]="10.135.75.26"

SSH_KEY="~/.ssh/poa"
LOCAL_GENESIS="genesis.json"
LOCAL_BOOT_KEY="$(pwd)/resources/poa-private-net/boot.key"
LOCAL_IDENTITIES="$(pwd)/resources/poa-private-net/identities.js"
LOCAL_RUN_GETH_SCRIPT="$(pwd)/run-geth.sh"
LOCAL_RUN_ATTACH_NODES_SCRIPT="$(pwd)/attach-nodes.sh"
LOCAL_BOOTNODE_SCRIPT="$(pwd)/start-bootnode.sh"

SCP_DEPLOY_TARGET_GENESIS="provotum/genesis.json"
SCP_DEPLOY_TARGET_BOOT_KEY="provotum/boot.key"
SCP_DEPLOY_TARGET_IDENTITIES="provotum/identities.js"
SCP_DEPLOY_TARGET_RUN_GETH_SCRIPT="provotum/run-geth.sh"
SCP_DEPLOY_TARGET_BOOTNODE_SCRIPT="provotum/start-bootnode.sh"

DEPLOY_TARGET_BOOT_KEY="/home/authority/provotum/boot.key"
DEPLOY_TARGET_GENESIS="/home/authority/provotum/genesis.json"
DEPLOY_TARGET_IDENTITIES="/home/authority/provotum/identities.js"
DEPLOY_TARGET_CHAINDATA="/home/authority/provotum/node/geth/*"
DEPLOY_TARGET_INIT_LOG="/home/authority/provotum/node/init.log"
DEPLOY_TARGET_CONSOLE_LOG="/home/authority/provotum/node/console.log"


# Clean up before starting
rm -rf $(pwd)/genesis.json;
rm -rf $(pwd)/privatekeys.json;

# calling key generation with node
printf "${CYAN}Generating keys using keythereum \n${NORMAL}"
output=$(node --no-deprecation steps/01-generate-keypairs/src/generateKeys.js);
status=$?;


echo ${output} >> $(pwd)/logs/output.log;
echo "${output}";

    if [[ ${status} -ne "0" ]]; then
        exit ${status};
    fi

printf "${NORMAL}"

# SSH to node, kill processes
printf "${CYAN} Killing all running geth instances on the sealer nodes \n${NORMAL}"
for entry in $SEALERS; do
  printf "${CYAN} → $entry \n${NORMAL}"
  ssh -i $SSH_KEY authority@$entry "sudo killall -q --signal SIGINT geth";
  ssh -i $SSH_KEY authority@$entry "sudo pkill -INT geth";
  #ssh -i $SSH_KEY authority@$entry "sudo killall -q --signal SIGINT bootnode";
  #ssh -i $SSH_KEY authority@$entry "sudo pkill -INT bootnode";
done
printf "${GREEN} ✔ Killed all running geth instances on the sealer nodes \n${NORMAL}"

# SSH to node, delete files
printf "${CYAN} Deleting old files from the sealer nodes \n${NORMAL}"
for entry in $SEALERS; do
  printf "${CYAN} → $entry \n${NORMAL}"
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_BOOT_KEY";
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_CHAINDATA";
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_GENESIS";
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_IDENTITIES";
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_INIT_LOG";
  ssh -i $SSH_KEY authority@$entry "sudo rm -rf $DEPLOY_TARGET_CONSOLE_LOG";
done

if [[ $? -ne "1" ]]; then
printf "${GREEN} ✔ Deleted all old files \n${NORMAL}"
fi

# Copy over newly generated genesis.key and boot.key
printf "${CYAN} SCP genesis.json and boot.key \n${NORMAL}"
for entry in $SEALERS; do
  printf "${CYAN} → $entry \n${NORMAL}"
  scp -i $SSH_KEY $LOCAL_GENESIS authority@$entry:~/$SCP_DEPLOY_TARGET_GENESIS;
  scp -i $SSH_KEY $LOCAL_BOOT_KEY authority@$entry:~/$SCP_DEPLOY_TARGET_BOOT_KEY;
  scp -i $SSH_KEY $LOCAL_IDENTITIES authority@$entry:~/$SCP_DEPLOY_TARGET_IDENTITIES;
  scp -i $SSH_KEY $LOCAL_RUN_GETH_SCRIPT authority@$entry:~/$SCP_DEPLOY_TARGET_RUN_GETH_SCRIPT;
done

#printf "${CYAN} Starting ufw with rulesets \n${NORMAL}"
#for entry in $SEALERS; do
#  NODENAME=$(echo "$entry"|cut -f1 -d.);
#  printf "${CYAN} → $entry ufw \n${NORMAL}"
#    ssh -i $SSH_KEY authority@$entry "sudo ufw default allow outgoing; sudo ufw allow 22; sudo ufw allow ssh; sudo ufw allow 8500/tcp; sudo ufw allow 30300; sudo ufw allow 30301; sudo ufw allow from 255.255.0.0; sudo ufw enable;";
#done
#if [[ $? -ne "1" ]]; then
#        printf "${GREEN} ✔ Started ufw \n${NORMAL}"
#fi

# Init all genesis blocks on all sealers
printf "${CYAN} Initializing genesis.json \n${NORMAL}"
for entry in $SEALERS; do
  printf "${CYAN} → $entry \n${NORMAL}"
  ssh -i $SSH_KEY authority@$entry "geth --datadir=./provotum/node $FLAGS init ./provotum/genesis.json 2>> ./provotum/node/init.log";
done
if [[ $? -ne "1" ]]; then
        printf "${GREEN} ✔ Initialized genesis.json \n${NORMAL}"
fi

# Start bootnode on sealer01
# Init all genesis blocks on all sealers
printf "${CYAN} Starting bootnode on sealer01 \n${NORMAL}"
  printf "${CYAN} → sealer01.provotum.ch \n${NORMAL}"
  scp -i $SSH_KEY $LOCAL_BOOTNODE_SCRIPT authority@$entry:~/$SCP_DEPLOY_TARGET_BOOTNODE_SCRIPT;
  #ssh -i $SSH_KEY authority@$entry "sudo chmod +x /home/authority/provotum/start-bootnode.sh; /home/authority/provotum/start-bootnode.sh";
  #bootnode -nodekey /home/authority/provotum/boot.key -verbosity 9 -addr :30310 2>&1 & 2>&1 &";
if [[ $? -ne "1" ]]; then
        printf "${GREEN} ✔ Started bootnode on sealer01 \n${NORMAL}"
fi

# Starting geth on all sealers using the correct configuration
printf "${CYAN} Starting geth \n${NORMAL}"

COUNTER=0
for entry in $SEALERS; do
  NODENAME=$(echo "$entry"|cut -f1 -d.);
  EXTERNAL_IP=${INT_IP[$COUNTER]}

  # ENODE_CUT[$i]=$(echo "${enodes[$i]//@*0/${ENODES_EXT[$i]}}")
  echo "$COUNTER";
  echo "$EXTERNAL_IP";
  printf "${CYAN} → NODENAME: $NODENAME \n${NORMAL}"
  printf "${CYAN} → $entry:$BASE_PORT/:$BASE_RPC_PORT \n${NORMAL}"
  #ssh -i $SSH_KEY authority@$entry "geth --datadir=./provotum/node --identity=$NODENAME --port=$BASE_PORT --rpc --rpccorsdomain='*' --rpcapi admin,net,eth,web3,miner,personal --rpcport=$BASE_RPC_PORT $FLAGS $DEV_FLAGS > ./provotum/node/console.log &";
  ssh -i $SSH_KEY authority@$entry "sudo chmod +x /home/authority/provotum/run-geth.sh; /home/authority/provotum/run-geth.sh $NODENAME $EXTERNAL_IP";
  #ssh -i $SSH_KEY authority@$entry "sudo chmod +x /home/authority/provotum/attach-nodes.sh; /home/authority/provotum/attach-nodes.sh";
  COUNTER=$[$COUNTER +1]
done
if [[ $? -ne "1" ]]; then
        printf "${GREEN} ✔ Started geth \n${NORMAL}"
fi

#printf "${CYAN} Connecting sealer01 with sealer02 \n${NORMAL}"
# save IP into variable, then get enode ID
#for entry in $SEALERS; do
#INTERNAL_IP=$(ssh -i $SSH_KEY authority@$entry "ifconfig|grep inet|head -3|tail -1|sed 's/\:/ /'|(awk '{print \$3}')");
#printf "${CYAN} ✔ $INTERNAL_IP \n${NORMAL}"
#done
#if [[ $? -ne "1" ]]; then
#        printf "${GREEN} ✔ Got IPs \n${NORMAL}"
#fi

bash attach-nodes.sh;
#ssh -i $SSH_KEY authority@sealer01.provotum.ch "geth --exec='miner.start()' attach http://localhost:8500";
#ssh -i $SSH_KEY authority@sealer02.provotum.ch "geth --exec='miner.start()' attach http://localhost:8500";
#ssh -i $SSH_KEY authority@sealer03.provotum.ch "geth --exec='miner.start()' attach http://localhost:8500";