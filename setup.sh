#!/usr/bin/env bash
# ------------------------------------------------------------------
# [Raphael Matile, Christian Killer] Setup Script
#          For the setup of a demo election for provotum
# ------------------------------------------------------------------

BLUE=$(tput setaf 4)
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)

# Init log file
rm logs/output.log
touch logs/output.log

shopt -s nullglob
for dir in steps/*/
do
	printf "${BLUE}#######################################\n";
    echo "Executing $dir"
    printf "${BLUE}#######################################\n${NORMAL}";
    ./${dir}/run.sh

    last_exit_status=$?
    if [[ ${last_exit_status} -ne "0" ]]; then
        exit ${last_exit_status};
    fi

    echo ""
done
shopt -u nullglob #revert nullglob back to it's normal default state

printf "${GREEN}[Done]" 
