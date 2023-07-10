#!/bin/bash

exec > "/var/log/ddeploy/cron.log" 2>&1
folder="$1"
token="$2"
name=$(basename "$folder")
export $(grep -v '^#' "$folder/.ddeploy.env" | xargs)
lock_file="/tmp/doc-$name.lock"

{
    flock -n 9 || exit 1

    function updateCommit() {
        local commit
        commit="$1"

        # Update the commit value in the JSON file
        jq --arg folder "$folder" --arg commit "$commit" 'map(if .folder == $folder then .commit = $commit else . end)' $base/configs/deploys.json > $base/configs/deploys.tmp
        mv $base/configs/deploys.tmp $base/configs/deploys.json
    }

    function remove_rebuild() {
        local pattern
        pattern=$(sed 's/[][\\^*$/.&]/\\&/g' <<< "$folder")
        sed -i "/$pattern/d" "$folders_file"
        echo "API ERROR - $(basename "$folder") removed from autobuild"
    }


    last_commit=$($base/helpers/fetchCommit.sh "$token")
    commit=$(jq -r --arg folder "$folder" '.[] | select(.folder == $folder) | .commit' $base/configs/deploys.json)

    if [[ -z "$last_commit" ]] || [[ "$last_commit" == "null" ]];then
        remove_rebuild
        exit 1
    fi

    if [[ "$last_commit" == "$commit" ]]; then
        echo "$name - Nothing to build - $(date +'%d/%m/%Y %H:%M:%S')"
    else
        updateCommit "$last_commit"
        cd "$folder"
        docker compose build --build-arg GIT="$GIT" >> "$build_log" 2>&1
        docker compose up -d >> "$build_log" 2>&1
        echo "$name - rebuilt successfully - $(date +'%d/%m/%Y %H:%M:%S')"
    fi

} 9>"$lock_file"
