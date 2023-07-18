base="/etc/ddeploy"
source "$base/helpers/repo.sh"
source $base/helpers/json.sh

if [ $# -lt 2 ]; then
    cat ./_help
    exit 1
fi

git="$(getItem "$WORKDIR" git)"
branch="$(getItem "$WORKDIR" branch)"
if [[ "$1" == "branch" ]]; then
    branch="$2"
    checkRepo "$git" "$branch"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" branch "$branch"
        echo "branch set to $branch"
    else
        echo "Error: cannot find branch $branch"
    fi
elif [[ "$1" == "repo" ]]; then
    git="$2"
    checkRepo "$git" "$branch"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" git "$git"
        echo "repo set to $git"
    else
        echo "Error: cannot find git $git"
    fi
elif [[ "$1" == "new" ]]; then
    git="$2"
    branch="$3"
    checkRepo "$git" "$branch"
    if [ $? -eq 0 ]; then
        setItem "$WORKDIR" git "$git"
        echo "repo set to $git"
    else
        echo "Error: cannot find git $git"
    fi
else
    cat ./_help
fi
