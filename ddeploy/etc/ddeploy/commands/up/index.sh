#!/usr/bin/env bash
import "repo"

if [[ $1 == "on" ]]; then
    if [[ ! -f "$base/configs/token" ]]; then
        echo -e "[ERROR] - Token must added first\ndoc token [Token]"
        exit 1
    fi
    if ! grep -q "$WORKDIR" $base/configs/rebuild.lst; then
        echo "$WORKDIR" >>$base/configs/rebuild.lst
    fi
    echo "Auto rebuild for $NAME is on"
    exit 0
fi

if [[ $1 == "off" ]]; then
    grep -v "$WORKDIR" $base/configs/rebuild.lst >$base/configs/rebuild.tmp
    mv $base/configs/rebuild.tmp $base/configs/rebuild.lst

    echo "Auto rebuild for $NAME is off"
    exit 0
fi

if [[ $1 == "list" ]]; then
    file_list="$base/configs/rebuild.lst"

    while IFS= read -r line; do
        folder=$(basename "$line")
        echo "$folder"
    done <"$file_list"

    exit 0
fi

if [[ $# -lt 1 ]]; then
    export COMMIT=$(fetchCommit "$WORKDIR")
    $scripts/deploy.sh
else
    script_path=$(readlink -f "$0")
    script_directory=$(dirname "$script_path")
    cat $script_directory/_help
fi
