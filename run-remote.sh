#/bin/bash

# Declaring colors
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)

ODROIDS="192.168.1.50
192.168.1.51
192.168.1.52
192.168.1.53"

printf "${CYAN}[remote-setup] ${NORMAL}Remote deployment starting. \n"

printf "${CYAN}[remote-setup] ${NORMAL}Kill everything that could interfere. \n"


printf "${CYAN}[bootnode] ${NORMAL}Starting bootnode \n"
# this has to be called from /resources/poa-private-net, so either cd there or let it be
bootnode -nodekey boot.key -verbosity 9 -addr :30310 > /dev/null 2>&1 &

for entry in $ODROIDS; do
	
    ping -c 1 -t 1 $entry > /dev/null 2> /dev/null  # ping and discard output
    if [ $? -eq 0 ]; then  # check the exit code
    	printf "${GREEN}[$entry] \xE2\x9C\x94 running ${NORMAL}\n"
    	printf "${CYAN}[$entry] ${NORMAL}Make sure geth is not running \n"	
		printf "${CYAN}[$entry] ${NORMAL}Copy genesis file \n"
		printf "${CYAN}[$entry] ${NORMAL}Initialize genesis file \n"
		printf "${CYAN}[$entry] ${NORMAL}Starting geth \n"
    	# Call function or directly do all the stuff here
        # you could send this to a log file by using the >>pinglog.txt redirect
    else
        printf "${RED}[$entry] not running ${NORMAL}\n"
    fi
done

