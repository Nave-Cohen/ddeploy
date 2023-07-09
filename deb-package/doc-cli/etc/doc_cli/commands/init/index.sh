#!/usr/bin/env bash

# Check if the current directory is already a runner environment
folder=$(/usr/bin/env bash "$base/helpers/isWorkdir.sh")
if [[ -n $folder ]]; then
    echo "$(basename "$folder") is Already a runner environment"
    exit 1
fi
# Check if the required arguments are provided
if [ $# -lt 2 ]; then
    echo "[ERROR] - doc init [github url] [branch name]"
    exit 1
fi

GIT_URL="${1%.git}"
BRANCH="$2"
git_status=$(curl -s -o /dev/null -w "%{http_code}" "$GIT_URL/tree/$BRANCH")

# Check if the GitHub URL and branch exist
if [[ $git_status != "200" ]] ; then
    echo "[ERROR] - github url or branch-name are wrong."
    exit 1
fi

# Copy necessary files from /etc/doc_cli/init/
cp -r /etc/doc_cli/init/. .
echo + docker-compose.yml
echo + app/Dockerfile
echo + entrypoint

# Check if .env file exists
if [[ ! -f ".env" ]]; then
    touch .env
    echo "+ .env file created."
fi

# Create .runner.env file
echo -e "GIT=$1\nBRANCH=$2\nDOMAIN=#example.com\nMAIL=\nBACKEND_IP=\nBACKEND_PORT=3000\n" > .runner.env
echo "+ .runner.env"
echo ".runner.env must be edited."

export $(grep -v '^#' ".runner.env" | xargs)
# Extract repository and commit information
last_commit=$(/usr/bin/env bash /etc/doc_cli/helpers/fetchCommit.sh)

# Update the JSON file with the new item
json_file="/etc/doc_cli/configs/enviorments.json"
new_item=$(jq -n --arg folder "$PWD" --arg commit "$last_commit" '{"folder": $folder, "commit": $commit}')
jq --argjson new_item "$new_item" '. + [$new_item]' "$json_file" > "$json_file.tmp" && \
mv "$json_file.tmp" "$json_file"
