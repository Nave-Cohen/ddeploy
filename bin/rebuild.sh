#!/bin/bash
export workdir="$PWD"
export $(grep -v '^#' .runner | xargs)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
export GIT_REF=https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH
export JSON_RES=$(curl -s --request GET "$GIT_REF" --header "Authorization: Bearer $TOKEN" | jq -c .)

last_commit=$(echo "$JSON_RES" | jq -r ".object.sha")

if [ ! "$last_commit" == "$COMMIT" ]; then
    bash $script_dir/fetch.sh
    bash $script_dir/up.sh
fi