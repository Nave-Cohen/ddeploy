#!/usr/bin/env bash
source $base/helpers/json.sh

# Check if the current directory is already a runner environment
if isWorkdir $WORKDIR; then
    echo "$(basename "$WORKDIR") is Already a runner environment"
    exit 1
fi

#Run cleaner to clean deploment.json if there is entry
$base/maintence/cleaner.sh

# Check if the required arguments are provided
if [ $# -lt 2 ]; then
    echo "[ERROR] - doc init [github url] [branch name]"
    exit 1
fi

GIT="$1"
GIT_URL="${1%.git}"
BRANCH="$2"

# Check if the GitHub URL and branch exist
git_status=$(curl -s -o /dev/null -w "%{http_code}" "$GIT_URL/tree/$BRANCH")
if [[ $git_status != "200" ]] ; then
    echo "[ERROR] - github url or branch-name are wrong."
    exit 1
fi
source "$base/helpers/repo"

# Extract repository and commit information
commit=$(fetchCommit "$PWD")
if [[ -z "$commit" ]]; then
    echo -e "Faild to fetch branch commit\naAbort!"
    exit 1
fi

# Copy necessary files from $base/init/
cp -r $base/init/docker-compose.yml .
echo + docker-compose.yml
cp -r $base/init/app .
echo + app/Dockerfile
cp -r $base/init/entrypoint .
echo + entrypoint


# Create .ddeploy.env file
if [[ ! -f ".ddeploy.env" ]]; then
    cp -r $base/init/.ddeploy.env .
    sed -i "s|^GIT=.*|GIT=$GIT|" .ddeploy.env
    sed -i "s/^BRANCH=.*/BRANCH=$BRANCH/" .ddeploy.env
    echo "+ .ddeploy.env"
    echo ".ddeploy.env must be edited."
fi

# Update the JSON file with the new item
addProject "$PWD" "$commit"
 # Print success message
echo "Runner environment initialized successfully."