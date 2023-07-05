#!/bin/bash

# Set the script directory and current working directory
export script_dir="/usr/local/bin/doc_cli"
workdir="$PWD"

# Validate arguments using validate.sh
source "$script_dir/validate.sh" "$@"

# Handle the 'init' command separately
if [[ $1 == "init" ]]; then
    bash "$script_dir/init.sh"
    exit 0
fi

# Execute the specified script
bash "$script_dir/$1.sh"
