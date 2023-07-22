source $base/helpers/json.sh
source $base/helpers/enviorment.sh

_kill() {
    local folder=$1
    load_vars $folder
    local conf="$DOMAIN.conf"
    local template_conf="$conf.template"
    rm "$base/entrypoints/nginx_templates/$template_conf" &>/dev/null
    docker exec nginx rm /etc/nginx/conf.d/$conf &>/dev/null && nginx -s reload &>/dev/null
    docker compose -f "$folder/docker-compose.yml" down
}

if [ $# -gt 0 ]; then
    if [[ "$1" = "all" ]]; then
        echo "Stop and kill containers from all ddeploy projects..."
        folders=$(getAll "folder")
        read -a folders < <(getAll "folder")
        for folder in "${folders[@]}"; do
            echo "  - $(basename "$folder")"
            _kill "$folder"
        done
    elif folder=$(isWorkdir $1); then
        echo "Stop and kill containers from $(basename "$folder")..."
        _kill $folder
    else
        echo "$1 is not ddeploy enviorment."
        exit 1
    fi
else
    if ! isWorkdir $WORKDIR; then
        echo "$WORKDIR is not ddeploy enviorment."
        exit 1
    else
        echo "Stop and kill containers from $(basename "$WORKDIR")..."
        _kill "$WORKDIR"
    fi
fi
