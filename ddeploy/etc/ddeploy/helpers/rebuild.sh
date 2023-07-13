#!/usr/bin/env bash

exec &>>"/var/log/ddeploy/cron.log"
folder="$1"
name=$(basename "$folder")

source $base/helpers/repo.sh
isUpdated "$folder"

if [[ $? -eq 1 ]]; then
    echo "$name - Nothing to build - $(date +'%d/%m/%Y %H:%M:%S')"
elif [[ $? -eq 2 ]]; then
    echo -e "Error: GitHub api error, try to check token\nRemove $name from autobuild"
    sed -i "$folder/d" "$list_file"
else
    docker compose -f "$folder/docker-compose.yml" up -d >>"$build_log" 2>&1
    echo "$name - rebuilt successfully - $(date +'%d/%m/%Y %H:%M:%S')"
fi
