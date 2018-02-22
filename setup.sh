#!/usr/bin/env bash

# Init log file
rm logs/output.log
touch logs/output.log

shopt -s nullglob
for dir in steps/*/
do
    echo "#######################################"
    echo "Executing step $dir"
    echo "#######################################"
    ./${dir}/run.sh

    last_exit_status=$?
    if [[ ${last_exit_status} -ne "0" ]]; then
        exit ${last_exit_status};
    fi

    echo ""
done
shopt -u nullglob #revert nullglob back to it's normal default state

echo "Done"
