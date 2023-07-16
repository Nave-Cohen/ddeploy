base=/etc/ddeploy
source /etc/ddeploy/helpers/json.sh

fetchCommit() {
    local token_path="$base/configs/token"
    local project="$1"
    local branch
    local repo
    if [[ $# -lt 3 ]]; then
        branch=$(grep 'BRANCH=' $project/.ddeploy.env | cut -d'=' -f2-)
        repo=$(grep 'GIT=' $project/.ddeploy.env | cut -d'=' -f2- | sed -e 's#.*github.com/##' -e 's#\.git$##')
    else
        repo="$2"
        branch="$3"
    fi
    local api_url="https://api.github.com/repos/$repo/git/refs/heads/$branch"

    local response
    if [ -f "$token_path" ]; then
        response=$(curl -s --request GET --url "$api_url" -H "Authorization: Bearer $(cat $token_path)" | jq -c .)
    else
        response=$(curl -s --request GET --url "$api_url" | jq -c .)
    fi
    response=$(echo "$response" | jq -r '.object.sha')

    if [[ "$response" == "null" ]]; then
        echo
    else
        echo "$response"
    fi
}
isUpdated() {
    local project="$1"
    local last_commit=$(fetchCommit "$project")
    local commit=$(getItem "$project" "commit")
    if [[ -z "$last_commit" ]]; then
        return 2
    elif [[ "$last_commit" == "$commit" ]]; then
        return 1
    else
        setItem "$project" "commit" "$last_commit"
        return 0
    fi
}
