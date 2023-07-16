#!/usr/bin/env bash

exec &>>"/var/log/ddeploy/cleaner.log"
base="/etc/ddeploy"
source $base/helpers/json.sh

folders=$(getAll "folder")
read -a folders < <(getAll "folder")
for folder in "${folders[@]}"; do
    if ! isWorkdir "$folder"; then
        rmProject "$folder"
    fi
done
