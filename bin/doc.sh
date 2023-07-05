#!/bin/bash


workdir="$PWD"
cwd=$(echo $PWD | xargs basename)

runner_file=""
parent_dir=$(dirname "$workdir")
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"



# Start searching from the current directory and go up the directory tree
while [[ $workdir != "$HOME" ]]; do
    runner_file="$workdir/.runner"

    if [[ -f $runner_file ]]; then
        export $(grep -v '^#' "$workdir/.runner" | xargs)
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
    echo "GIT=*** must be defined in .runner file"
    exit 1
elif  [ -z "$DOMAIN" ]; then
    echo "DOMAIN=*** must be defined in .runner file"
    exit 1
elif   [ -z $BRANCH ]; then
    echo "BRANCH=*** must be defined in .runner file"
    exit 1
fi

bash $script_dir/$1.sh