#!/usr/bin/env bash

source /etc/ddeploy/helpers/status.sh
source /etc/ddeploy/helpers/json.sh

folders=$(getAll "folder")
read -a folders < <(getAll "folder")
for folder in "${folders[@]}"; do
    output+="$(basename "$folder"),$(status "$folder")"
done
output="Project,HTTP Status,Docker status,Last Build,Branch,Commit\n$output"
echo -e $output | column -t -s ','
