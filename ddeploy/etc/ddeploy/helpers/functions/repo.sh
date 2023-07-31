#!/bin/bash
import "token"
import "string"
import "json"

fetchCommit() {
    local api_url=$(get_repo_api)

    if token=$(get_token); then
        local response=$(curl -s --request GET --url "$api_url" -H "Authorization: Bearer $token" | jq -c . | jq -r '.object.sha')
    else
        local response=$(curl -s --request GET --url "$api_url" | jq -c . | jq -r '.object.sha')
    fi

    if [[ "$response" == "null" ]]; then
        echo
    else
        echo "$response"
    fi
}

get_first_commit() {
    local full_repo=$(remove "$1" "https://" "github.com/" ".git")
    local api_url="https://api.github.com/repos/$full_repo/git/refs/heads/$2"
    local response=$(curl -s --request GET --url "$api_url" | jq -c . | jq -r '.object.sha')

    if [[ "$response" == "null" ]]; then
        echo
    else
        echo "$response"
    fi
}

isUpdated() {
    local last_commit=$(fetchCommit)

    if [[ -z "$last_commit" ]]; then
        return 2
    elif [[ "$last_commit" == "$COMMIT" ]]; then
        return 1
    else
        setItem "$WORKDIR" "commit" "$last_commit"
        return 0
    fi
}

repoExist() {
    local GIT_URL="${1%.git}"
    local BRANCH="$2"

    git_status=$(curl -s -o /dev/null -w "%{http_code}" "$GIT_URL/tree/$BRANCH")
    if [[ $git_status != "200" ]]; then
        return 1
    fi
    return 0
}

# Create the GitHub personal access token using cURL and parse the response
get_repo_api() {
    local full_repo=$(remove "$GIT" "https://" "github.com/" ".git")
    echo "https://api.github.com/repos/$full_repo/git/refs/heads/$BRANCH"
}
get_username() {
    local full_repo=$(remove "$GIT" "https://" "github.com/" ".git")
    echo "$(extract "$full_repo" "/" 1)"
}

get_repo() {
    local full_repo=$(remove "$GIT" "https://" "github.com/" ".git")
    echo "$(extract "$full_repo" "/" 2)"
}
