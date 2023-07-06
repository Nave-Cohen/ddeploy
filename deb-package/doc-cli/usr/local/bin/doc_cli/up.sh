#!/bin/bash


if [[ $2 == "on" ]]; then
    if [[ ! -z $3 ]]; then
        if ! grep -q "$workdir" /etc/doc_cli/configs/rebuild.txt; then
            echo "$workdir|$3" >> /etc/doc_cli/configs/rebuild.txt
        fi
        echo "Auto rebuild for $NAME is on"
        exit 0
    else
        echo "Must provide a token"
        exit 0
    fi
elif [[ $2 == "off" ]]; then
    grep -v "$workdir" /etc/doc_cli/configs/rebuild.txt > /etc/doc_cli/configs/rebuild.tmp
    mv /etc/doc_cli/configs/rebuild.tmp /etc/doc_cli/configs/rebuild.txt
    echo "Auto rebuild for $NAME is off"
    exit 0
elif [[ $2 == "list" ]]; then
    file_list="/etc/doc_cli/configs/rebuild.txt"
    # Read each line from the file
    while IFS= read -r line; do
    # Extract the directory name from the file path
    folder=$(basename "$line")
    echo "$folder"
    done < "$file_list"
    exit 0
fi

cd $workdir
command docker compose build --build-arg GIT="$GIT"
command docker compose up -d