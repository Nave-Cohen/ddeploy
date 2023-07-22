#!/usr/bin/env bash

exec &>>"/var/log/ddeploy/cleaner.log"
base="/etc/ddeploy"
source $base/helpers/json.sh

folders=$(getAll "folder")
read -a folders < <(getAll "folder")
for folder in "${folders[@]}"; do
    if ! isWorkdir "$folder"; then
        rmProject "$folder"
        echo "$folder removed because $folder/.ddeploy.env not found or folder removed - $(date +'%d/%m/%Y %H:%M:%S')"
    fi
done
