import "repo"

get_repo
exit 0
if [ $# -lt 2 ]; then
    cat ./_help
    exit 1
fi

if [[ "$1" == "branch" && -n $2 ]]; then
    branch="$2"
    repoExist "$GIT" "$branch"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" branch "$branch"
        echo "branch set to $branch"
    else
        echo "Error: cannot find branch $branch"
        echo "ddeploy repo branch [branch name]"
    fi
elif [[ "$1" == "repo" && -n $2 ]]; then
    git="$2"
    repoExist "$git" "$BRANCH"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" git "$git"
        echo "repo set to $git"
    else
        echo "Error: cannot find repository $git"
        echo "ddeploy repo repo [repository url]"
    fi
elif [[ "$1" == "new" && -n $2 && -n $3 ]]; then
    git="$2"
    branch="$3"
    repoExist "$git" "$branch"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" git "$git"
        echo "repo set to $git"
    else
        echo "Error: cannot find repository $git with branch $branch"
        echo "ddeploy repo new [repository url] [branch name]"

    fi
else
    cat ./_help
fi
