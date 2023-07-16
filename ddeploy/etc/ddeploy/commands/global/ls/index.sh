#!/usr/bin/env bash

source /etc/ddeploy/helpers/status.sh
source /etc/ddeploy/helpers/json.sh

printf "%-20s %-20s %-20s %-20s %-15s %-20s\n" "Project" "HTTP Status" "Docker Status" "Last build" "Branch" "Commit"

folders=$(getAll "folder")
read -a folders < <(getAll "folder")
for folder in "${folders[@]}"; do
    projectStatus "$folder" "all"
done
