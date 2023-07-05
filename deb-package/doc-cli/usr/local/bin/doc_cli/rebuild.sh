#!/bin/bash
last_commit=$(echo "$JSON_RES" | jq -r ".object.sha")

if [ ! "$last_commit" == "$COMMIT" ]; then
    bash $script_dir/fetch.sh
    bash $script_dir/up.sh
fi