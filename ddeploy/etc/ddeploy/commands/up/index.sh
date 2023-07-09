#!/bin/bash
NAME=$(basename "$WORKDIR")
if [[ $1 == "on" ]]; then
    if [[ ! -f "$base/configs/token" ]]; then
        echo -e "[ERROR] - Token must added first\ndoc token [Token]"
        exit 1
    fi
    if ! grep -q "$WORKDIR" $base/configs/rebuild.lst; then
        echo "$WORKDIR" >> $base/configs/rebuild.lst
    fi
    echo "Auto rebuild for $NAME is on"
    exit 0
fi

if [[ $1 == "off" ]]; then
    grep -v "$WORKDIR" $base/configs/rebuild.lst > $base/configs/rebuild.tmp
    mv $base/configs/rebuild.tmp $base/configs/rebuild.lst

    echo "Auto rebuild for $NAME is off"
    exit 0
fi

if [[ $1 == "list" ]]; then
    file_list="$base/configs/rebuild.lst"
    
    while IFS= read -r line; do
        folder=$(basename "$line")
        echo "$folder"
    done < "$file_list"
    
    exit 0
fi

if [[ $1 == "-d" ]]; then
    command docker compose build --build-arg GIT="$GIT"
    command docker compose up -d
elif [[ $# -lt 1 ]];then 
    command docker compose build --build-arg GIT="$GIT"
    command docker compose up
else 
    cat ./_help
fi