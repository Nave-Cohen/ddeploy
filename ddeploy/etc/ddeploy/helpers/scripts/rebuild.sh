#!/usr/bin/env bash

exec &>>"$cron_log"

folder="$1"
name=$(basename "$folder")

isUpdated "$folder"

if [[ $? -eq 1 ]]; then
    echo "$name - Nothing to build - $(date +'%d/%m/%Y %H:%M:%S')"
elif [[ $? -eq 2 ]]; then
    echo -e "Error: GitHub api error, try to check token\nRemove $name from autobuild"
    sed -i "$folder/d" "$rebuild_list"
else
    cd "$folder" && source $scripts/enviorment.sh "$folder" && $command_line "up" "-d" &>>"$build_log"
    echo "$name - rebuilt successfully - $(date +'%d/%m/%Y %H:%M:%S')"
fi
