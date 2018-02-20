#!/usr/bin/env bash

# Init log file, if not existing
touch logs/output.log

shopt -s nullglob
for file in steps/*/**
do
    echo "#######################################"
    echo "Executing step $file"
    echo "#######################################"
    ./${file}

    last_exit_status=$?
    if [[ ${last_exit_status} -ne "0" ]]; then
        exit ${last_exit_status};
    fi

    echo ""
done
shopt -u nullglob #revert nullglob back to it's normal default state

echo "Done"
