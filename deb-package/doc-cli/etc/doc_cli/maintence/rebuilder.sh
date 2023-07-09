#!/bin/bash

folders_file="$base/configs/rebuild.txt"
build_log="/var/log/doc_cli/build.log"

# Array to store child process IDs
pids=()

token=$(cat "$base/configs/token")

for i in {1..11}; do
    while IFS='\n' read -r folder; do
        if [[ -n "$folder" ]]; then
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
