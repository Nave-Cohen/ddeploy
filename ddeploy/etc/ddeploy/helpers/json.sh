json_file="/etc/ddeploy/configs/deploys.json"

isWorkdir() {
    # If the input is not a valid directory path, assume it's a basename and search in the JSON data
    local WORKDIR="$1"
    local folder=$(jq -r --arg search "$WORKDIR" 'map(select(.folder | endswith($search))) | .[0].folder' "$json_file")
    if [ -z "$folder" ] || [ ! -d "$folder" ] || [ ! -f "$folder/.ddeploy.env" ]; then
        return 1
    else
        echo $folder
        return 0
    fi
}

addProject() {
    local folder="$1"
    local commit="$2"
    local git="$3"
    local branch="$4"
    local port=$(getFreePort)
    jq --arg folder "$folder" --arg commit "$commit" --arg git "$git" --arg branch "$branch" --arg port "$port" \
        '. += [{"folder": $folder, "commit": $commit, "git": $git, "branch": $branch, "port": $port}]' $json_file >tmp.json && mv tmp.json $json_file
}
rmProject() {
    local workdir="$1"
    new_json=$(jq --arg wd "$workdir" '[.[] | select(.folder != $wd)]' $json_file)
    echo "$new_json" >"$json_file"
}
getProject() {
    local workdir="$1"
    item=$(jq -r --arg wd "$workdir" '.[] | select(.folder == $wd)' $json_file)
    echo "$item"
}

getAll() {
    local item="$1"
    readarray -t result < <(jq -r --arg item "$item" '.[] | .[$item]' $json_file)
    echo "${result[@]}"
}

setItem() {
    local workdir="$1"
    local key="$2"
    local val="$3"
    jq --arg wd "$workdir" --arg k "$key" --arg v "$val" \
        'map(if .folder == $wd then .[$k] = $v else . end)' $json_file >tmp.json && mv tmp.json $json_file
}

getItem() {
    local workdir="$1"
    local key="$2"
    local item=$(jq -r --arg wd "$workdir" --arg k "$key" '.[] | select(.folder == $wd) | .[$k]' $json_file)
    echo "$item"
}

getFreePort() {
    ports=($(getAll "port"))
    max_port=$(get_max "${ports[@]}")
    free_port=$((max_port + 1))
    echo "$free_port"
}

get_max() {
    local array=("$@")
    local max=2999
    for num in "${array[@]}"; do
        if ((num > max)); then
            max=$num
        fi
    done
    echo "$max"
}
