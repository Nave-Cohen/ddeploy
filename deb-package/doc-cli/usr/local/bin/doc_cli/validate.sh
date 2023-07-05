#!/bin/bash

# Function to display script usage and options
function help() {
    echo "Usage: doc [option]"
    echo "Options:"
    echo "  status   - Get web and compose status"
    echo "  services - List services"
    echo "  up       - Start the application"
    echo "  fetch    - Fetch latest changes"
    echo "  rebuild  - Rebuild the application"
}

# Check if a runner environment was found
if [[ $workdir == "$HOME" ]]; then
    cwd=$(basename "$PWD")
    echo "Error: '$cwd' is not a runner environment"
    exit 1
fi

# Check if an option is provided
# Check if the provided option script exists
if [ -z "$1" ] || [[ ! -f "$script_dir/$1.sh" ]]; then
    echo "Error: Invalid option: $1"
    help
    exit 1
fi

# Find the runner environment by searching up the directory tree
while [[ $workdir != "$HOME" ]]; do
    runner_file="$workdir/.runner.env"
    if [[ -f $runner_file ]]; then
        break
    fi
    workdir=$(dirname "$workdir")
done

# Export workdir and load variables from .runner.env
export $(grep -v '^#' "$workdir/.runner.env" | xargs)

# Validate required variables
required_variables=("GIT" "DOMAIN" "BRANCH" "MAIL" "BACKEND_IP" "BACKEND_PORT")
for variable in "${required_variables[@]}"; do
    if [[ -z "${!variable}" ]]; then
        echo "Error: $variable must be defined in .runner.env file"
        exit 1
    fi
done