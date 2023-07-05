#!/bin/bash


if [ -z "$1" ]; then
    echo "useage: doc [option]"
    echo "options:"
    echo " status - get web and compose status"
    echo " services "
    echo " up"
    echo " fetch"
    echo " rebuild"
    exit 1
fi



workdir="$PWD"
cwd=$(echo $PWD | xargs basename)

runner_file=""
parent_dir=$(dirname "$workdir")
script_dir="/usr/local/bin/doc_cli"



# Start searching from the current directory and go up the directory tree
while [[ $workdir != "$HOME" ]]; do
    runner_file="$workdir/.runner.env"

    if [[ -f $runner_file ]]; then
        export $(grep -v '^#' "$workdir/.runner.env" | xargs)
        export workdir="$workdir"
        REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
        export GIT_REF=https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH
        export JSON_RES=$(curl -s --request GET "$GIT_REF" --header "Authorization: Bearer $TOKEN" | jq -c .)
        break
    fi

    workdir=$parent_dir
    parent_dir=$(dirname "$workdir")
done


if [[ $workdir == "$HOME" ]]; then
    echo "$cwd is not runner enviorment"
    exit 1
fi

if [ -z "$GIT" ]; then
    echo "GIT=*** must be defined in .runner.env file"
    exit 1
elif  [ -z "$DOMAIN" ]; then
    echo "DOMAIN=*** must be defined in .runner.env file"
    exit 1
elif   [ -z $BRANCH ]; then
    echo "BRANCH=*** must be defined in .runner.env file"
    exit 1
fi

bash $script_dir/$1.sh