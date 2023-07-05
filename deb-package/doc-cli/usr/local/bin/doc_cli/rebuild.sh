#!/bin/bash

trimmed_commit=$(echo "$COMMIT" | awk '{$1=$1};1')
trimmed_last_commit=$(echo "$JSON_RES" | jq -r '.object.sha | tostring | rtrimstr("\n")')

if [[ "$trimmed_last_commit" == "$trimmed_commit" ]]; then
    echo "Nothing to build"
else
    bash "$script_dir/fetch.sh"
    bash "$script_dir/up.sh"
fi