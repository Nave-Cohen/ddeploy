#!/bin/bash

folders_file="/etc/doc_cli/configs/rebuild.txt"
build_log="/var/log/doc_cli/build.log"
folder="$1"
token="$2"
name=$(basename "$folder")
export $(grep -v '^#' "$folder/.runner.env" | xargs)
lock_file="/tmp/doc-$name.lock"

{
    flock -n 9 || exit 1

    function updateCommit() {
        local folder commit
        folder="$1"
        commit="$2"

        # Update the commit value in the JSON file
        jq --arg folder "$folder" --arg commit "$commit" 'map(if .folder == $folder then .commit = $commit else . end)' /etc/doc_cli/configs/enviorments.json > /etc/doc_cli/configs/enviorments.tmp
        mv /etc/doc_cli/configs/enviorments.tmp /etc/doc_cli/configs/enviorments.json
    }

    last_commit=$(/usr/bin/env bash /etc/doc_cli/helpers/fetchCommit.sh "$token")
    commit=$(jq -r --arg folder "$folder" '.[] | select(.folder == $folder) | .commit' /etc/doc_cli/configs/enviorments.json)

    if [[ "$last_commit" == "$commit" ]]; then
        echo "$name - Nothing to build - $(date +'%d/%m/%Y %H:%M:%S')"
    else
        updateCommit "$folder" "$last_commit"
        cd "$folder"
        docker compose build --build-arg GIT="$GIT" >> "$build_log" 2>&1
        docker compose up -d >> "$build_log" 2>&1
        echo "$name - rebuilt successfully - $(date +'%d/%m/%Y %H:%M:%S')"
    fi

} 9>"$lock_file"
