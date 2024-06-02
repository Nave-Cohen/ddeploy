#!/usr/bin/env bash

# Check if the current directory is already a runner environment
if isWorkdir $PWD; then
    echo "$(basename "$PWD") is Already a runner environment"
    exit 1
fi

# Check if the required arguments are provided
if [ $# -lt 2 ]; then
    echo "[ERROR] - ddeploy init [github url] [branch name]"
    exit 1
fi

import "repo"

GIT="$1"
BRANCH="$2"

# Check if the GitHub URL and branch exist
if ! repoExist "$GIT" "$BRANCH"; then
    echo "[ERROR] - github url or branch-name are wrong."
    exit 1
fi

# Extract repository and commit information
commit=$(get_first_commit "$GIT" "$BRANCH")
if [[ -z "$commit" ]]; then
    echo -e "Faild to fetch branch commit\naAbort!"
    exit 1
fi

# Copy necessary files from $base/init/
cp -r $base/init/docker-compose.yml .
echo + docker-compose.yml
cp -r $base/init/mongo-compose.yml .
echo + mongo-compose.yml
cp -r $base/init/mysql-compose.yml .
echo + mysql-compose.yml
cp -r $base/init/app .
echo + app/Dockerfile
cp -r $base/init/entrypoint .
echo + entrypoint

# Create .ddeploy.env file
if [[ ! -f ".ddeploy.env" ]]; then
    cp -r $base/init/.ddeploy.env ./.ddeploy.env
    echo "+ .ddeploy.env"
    echo ".ddeploy.env must be edited."
fi

addProject "$PWD" "$commit" "$GIT" "$BRANCH"
# Print success message
echo "Runner environment initialized successfully."
