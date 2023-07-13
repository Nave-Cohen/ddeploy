#!/usr/bin/env bash

export base="/etc/ddeploy"
export list_file="$base/configs/rebuild.lst"
export build_log="/var/log/ddeploy/build.log"

source $base/helpers/json.sh
exec > "/var/log/ddeploy/cron.log" 2>&1
# Array to store child process IDs
pids=()

token=$(cat "$base/configs/token")

for i in {1..11}; do
    while IFS= read -r folder; do
        if isWorkdir "$folder"; then
            ($base/helpers/rebuild.sh "$folder") &
            # Store the PID of the background process
            pids+=($!)
        else
            echo "$(basename "$folder") is not ddeploy enviorment, Remove from auto build"
            sed -i "$folder/d" "$list_file"
        fi
    done < "$list_file"

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
