#!/bin/bash

isWorkdir() {
    # If the input is not a valid directory path, assume it's a basename and search in the JSON data
    WORKDIR="$1"
    local folder=$(jq -r --arg search "$WORKDIR" 'map(select(.folder | endswith($search))) | .[0].folder' "$deploys_json")
    if [ -z "$folder" ] || [ ! -d "$folder" ] || [ ! -f "$folder/.ddeploy.env" ]; then
        return 1
    else
        export WORKDIR="$folder"
        return 0
    fi
}

addProject() {
    local folder="$1"
    local commit="$2"
    local git="$3"
    local branch="$4"
    jq --arg folder "$folder" --arg commit "$commit" --arg git "$git" --arg branch "$branch" \
        '. += [{"folder": $folder, "commit": $commit, "git": $git, "branch": $branch}]' $deploys_json >tmp.json && mv tmp.json $deploys_json
}
rmProject() {
    local workdir="$1"
    new_json=$(jq --arg wd "$workdir" '[.[] | select(.folder != $wd)]' $deploys_json)
    echo "$new_json" >"$deploys_json"
}
getProject() {
    local workdir="$1"
    item=$(jq -r --arg wd "$workdir" '.[] | select(.folder == $wd)' $deploys_json)
    echo "$item"
}

getAll() {
    local item="$1"
    readarray -t result < <(jq -r --arg item "$item" '.[] | .[$item]' $deploys_json)
    echo "${result[@]}"
}

setItem() {
    local workdir="$1"
    local key="$2"
    local val="$3"
    jq --arg wd "$workdir" --arg k "$key" --arg v "$val" \
        'map(if .folder == $wd then .[$k] = $v else . end)' $deploys_json >tmp.json && mv tmp.json $deploys_json
}

getItem() {
    local workdir="$1"
    local key="$2"
    local item=$(jq -r --arg wd "$workdir" --arg k "$key" '.[] | select(.folder == $wd) | .[$k]' $deploys_json)
    echo "$item"
}
