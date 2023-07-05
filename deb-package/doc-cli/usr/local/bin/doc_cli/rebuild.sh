#!/bin/bash

REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
export GIT_REF="https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH"

function updateCommit(){
    sed -E "s/(COMMIT=).*/\1$commit/" "$workdir/.runner.env" > "$workdir/.runner.env.tmp"
    echo "" >> "$workdir/.runner.env.tmp"  # Add an empty line at the end
    mv "$workdir/.runner.env.tmp" "$workdir/.runner.env"
}

JSON_RES=$(curl -s --request GET "$GIT_REF" | jq -c .)

trimmed_commit=$(echo "$COMMIT" | awk '{$1=$1};1')
trimmed_last_commit=$(echo "$JSON_RES" | jq -r '.object.sha | tostring | rtrimstr("\n")')

if [[ "$trimmed_last_commit" == "$trimmed_commit" ]]; then
    echo "Nothing to build"
else
    updateCommit
    bash "$script_dir/up.sh"
fi