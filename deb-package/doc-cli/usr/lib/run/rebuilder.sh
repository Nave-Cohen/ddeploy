#!/bin/bash
folders_file="/etc/doc_cli/configs/rebuild.txt"

function updateCommit(){
    sed -E "s/(COMMIT=).*/\1$trimmed_last_commit/" "$1/.runner.env" > "$1/.runner.env.tmp"
    echo "" >> "$1/.runner.env.tmp"  # Add an empty line at the end
    mv "$1/.runner.env.tmp" "$1/.runner.env"
}

function build(){
    NAME=$(basename "$1")
    REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
    GIT_REF="https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH"
    JSON_RES=$(curl -s --request GET --url "$GIT_REF" --header "Authorization: Bearer $2" | jq -c .)
    trimmed_commit=$(echo "$COMMIT" | awk '{$1=$1};1')
    trimmed_last_commit=$(echo "$JSON_RES" | jq -r '.object.sha | tostring | rtrimstr("\n")')
    if [[ "$trimmed_last_commit" == "$trimmed_commit" ]]; then
        echo "$NAME - Nothing to build"
    else
        updateCommit "$1"
        cd $1
        command docker compose build --build-arg GIT="$GIT" >/var/log/doc_cli/build.log 2>&1
        command docker compose up -d >/var/log/doc_cli/build.log 2>&1
        echo "$NAME - rebuilded"
    fi
}

while IFS= read -r line
do
    if [ -n "$line" ]; then  # Check if the line is not empty
        folder=$(echo "$line" | cut -d '|' -f 1)
        token=$(echo "$line" | cut -d '|' -f 2)
        export $(grep -v '^#' "$folder/.runner.env" | xargs)
        output=$(build "$folder" "$token")
        echo "$output - $(date +'%d/%m/%Y %H:%M:%S')"
    fi
done < "$folders_file"

echo "rebuilder finished execution - $(date +'%d/%m/%Y %H:%M:%S')"
echo "build log can be found in /var/log/doc_cli/build.log"
printf -- "-%.0s" {1..70}
echo 