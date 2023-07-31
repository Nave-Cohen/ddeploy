#!/usr/bin/env bash
source /etc/ddeploy/helpers/scripts/loader.sh
import "json"
import "repo"

lock="/tmp/rebuilder.lock"

# Function to acquire the lock
acquire_lock() {
    flock -n 9 || exit 1
}

# Function to process each folder
process_folder() {
    local folder="$1"
    if isWorkdir "$folder"; then
        ($scripts/rebuild.sh "$folder") &
        # Store the PID of the background process
        pids+=($!)
    else
        echo "$(basename "$folder") is not a ddeploy environment. Removing it from auto build."
        sed -i "$folder/d" "$rebuild_list"
    fi
}

# Function to wait for child processes to finish
wait_for_children() {
    if [[ ${#pids[@]} -gt 0 ]]; then
        wait "${pids[-1]}"
    fi
}

# Function to perform the rebuild process
perform_rebuild() {
    for ((i = 1; i <= 11; i++)); do
        while IFS= read -r folder; do
            process_folder "$folder"
        done <"$rebuild_list"

        wait_for_children

        # Clear the array of child process IDs
        pids=()

        echo "rebuilder finished execution - $(date +'%d/%m/%Y %H:%M:%S')"
        echo "build log can be found in $build_log"
        printf -- "-%.0s" {1..70}
        echo
        sleep 5
    done
}

{
    acquire_lock
    exec &>>"$cron_log"

    # Array to store child process IDs
    pids=()

    perform_rebuild
} 9>"$lock"
