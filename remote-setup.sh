#/bin/bash

# Declaring colors
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)

ODROIDS="192.168.1.50"

printf "${CYAN}[poa-private-net - remote-setup] ${NORMAL}Make sure geth is not already running. \n"

killall -q --signal SIGINT geth &> /dev/null
sleep 1
killall -q geth &> /dev/null
bash poa-private-net teardown > /dev/null

printf "${CYAN}[poa-private-net - remote-setup] ${NORMAL}Remote deployment starting. \n"

printf "${CYAN}[poa-private-net - remote-setup] ${NORMAL}Starting bootnode \n"
bootnode -nodekey boot.key -verbosity 9 -addr :30310 > /dev/null 2>&1 &



for entry in $ODROIDS; do


if nc -z $entry 22; then
  echo "Port is listening"
else
  echo "Port is not listening"
fi

	printf "${CYAN}[$entry] ${NORMAL}Make sure geth is not running \n"
	
	printf "${CYAN}[$entry] ${NORMAL}Copy genesis file \n"
	
	printf "${CYAN}[$entry] ${NORMAL}Initialize genesis file \n"
	
	printf "${CYAN}[$entry] ${NORMAL}Starting geth \n"
	
	result=$(ssh root@192.168.1.50 "free -m | cat /proc/loadavg" 2>&1);
	echo "${result}";
done