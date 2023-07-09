#!/bin/bash

export base="/etc/ddeploy"
export folders_file="$base/configs/rebuild.lst"
export build_log="/var/log/ddeploy/build.log"
exec > "/var/log/ddeploy/cron.log" 2>&1

function checkEnviorment(){
    workdir="$1"
    folder=$(/usr/bin/env bash "$base/helpers/isWorkdir.sh" "$workdir")
    if [ -z "$folder" ]; then
        sed -i "$workdir/d" "$folders_file"
        echo -e "ddeploy Environment not found in $(basename "$workdir")\nRemoved from autobuild"
        return 1
    fi
    return 0
}

# Array to store child process IDs
pids=()

token=$(cat "$base/configs/token")

for i in {1..11}; do
    while IFS= read -r folder; do
        if [[ -n "$folder" ]] && checkEnviorment "$folder"; then
            (bash "$base/helpers/rebuild.sh" "$folder" "$token") &
            # Store the PID of the background process
            pids+=($!)
        fi
    done < "$folders_file"

    # Wait for the last child process to finish
    if [[ ${#pids[@]} -gt 0 ]]; then
        wait "${pids[-1]}"
    fi

    # Clear the array of child process IDs
    pids=()

    echo "rebuilder finished execution - $(date +'%d/%m/%Y %H:%M:%S')"
    echo "build log can be found in $build_log"
    printf -- "-%.0s" {1..70}
    echo
    sleep 5

done
