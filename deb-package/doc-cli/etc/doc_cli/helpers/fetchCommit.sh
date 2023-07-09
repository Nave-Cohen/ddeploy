repo=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
git_ref="https://api.github.com/repos/$repo/git/refs/heads/$BRANCH"

if [ $# -lt 1 ]; then
    json_res=$(curl -s --request GET --url "$git_ref" | jq -c .)
else
    json_res=$(curl -s --request GET --url "$git_ref" --header "Authorization: Bearer $1" | jq -c .)
fi

trimmed_last_commit=$(echo "$json_res" | jq -r '.object.sha | tostring | rtrimstr("\n")')
echo "$trimmed_last_commit"