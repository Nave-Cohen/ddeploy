#!/bin/bash
NAME=$(basename "$WORKDIR")
if [[ $1 == "on" ]]; then
    if [[ ! -f "$base/configs/token" ]]; then
        echo "[ERROR] - Token must added first\ndoc token [Token]"
        exit 1
    fi
    if ! grep -q "$WORKDIR" $base/configs/rebuild.txt; then
        echo "$WORKDIR|$2" >> $base/configs/rebuild.txt
    fi
    echo "Auto rebuild for $NAME is on"
    exit 0
fi

if [[ $1 == "off" ]]; then
    grep -v "$WORKDIR" $base/configs/rebuild.txt > $base/configs/rebuild.tmp
    mv $base/configs/rebuild.tmp $base/configs/rebuild.txt

    echo "Auto rebuild for $NAME is off"
    exit 0
fi

if [[ $1 == "list" ]]; then
    file_list="$base/configs/rebuild.txt"
    
    while IFS= read -r line; do
        folder=$(basename "$line")
        echo "$folder"
    done < "$file_list"
    
    exit 0
fi

if [ $# -lt 1 ]; then
command docker compose build --build-arg GIT="$GIT"
command docker compose up -d
else
    echo ./_help
fi