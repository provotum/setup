#/bin/bash

# Declaring colors
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)

for ip in 192.168.1.{1..256}; do  # for loop and the {} operator
    ping -c 1 $ip > /dev/null 2> /dev/null  # ping and discard output
    if [ $? -eq 0 ]; then  # check the exit code
    	printf "${GREEN}[$ip] \xE2\x9C\x94 running ${NORMAL}\n"
    	# Call function or directly do all the stuff here
        # you could send this to a log file by using the >>pinglog.txt redirect
    fi
done

