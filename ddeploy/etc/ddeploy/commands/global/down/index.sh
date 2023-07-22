#!/usr/bin/env bash

# Load helper scripts
source "$base/helpers/json.sh"
source "$base/helpers/enviorment.sh"

# The 'down' function stops and removes Docker containers associated with a ddeploy project.
down() {
    local folder=$1
    load_vars "$folder"
    docker compose -f "$folder/docker-compose.yml" down
}

# Check if any arguments are provided.
if [ $# -gt 0 ]; then
    if [[ "$1" = "all" ]]; then
        # Stop and remove containers from all ddeploy projects.
        echo "Stop and remove containers from all ddeploy projects..."
        folders=$(getAll "folder")
        read -a folders < <(getAll "folder")
        for folder in "${folders[@]}"; do
            echo "  - $(basename "$folder")..."
            down "$folder"
        done
    elif isWorkdir $1; then
        # Stop and remove containers from the specified ddeploy project.
        echo "Stop and remove containers from $(basename "$WORKDIR")..."
        down "$WORKDIR"
    else
        echo "$1 is not a ddeploy environment."
        exit 1
    fi
else
    # If no argument provided, stop and remove containers from the current ddeploy project.
    isWorkdir "$WORKDIR" || {
        echo "$WORKDIR is not a ddeploy environment."
        exit 1
    }
    echo "Stop and remove containers from $(basename "$WORKDIR")..."
    down "$WORKDIR"
fi
