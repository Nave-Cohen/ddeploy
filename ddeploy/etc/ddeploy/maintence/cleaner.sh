#!/usr/bin/env bash
source /etc/ddeploy/helpers/scripts/loader.sh
import "json"

exec &>>"$cleaner_log"

while :; do
    folders=$(getAll "folder")
    read -a folders < <(getAll "folder")
    for folder in "${folders[@]}"; do
        if ! isWorkdir "$folder"; then
            rmProject "$folder"
            echo "$folder removed because $folder/.ddeploy.env not found or folder removed - $(date +'%d/%m/%Y %H:%M:%S')"
        fi
    done
    sleep 10
done