source $base/helpers/json.sh
source $base/helpers/enviorment.sh
source $base/helpers/printer.sh
#!/usr/bin/env bash

# Load helper scripts
down() {
    local folder=$1
    load_vars $folder
    local conf="$NAME.conf"
    local template_conf="$conf.template"
    rm -f "$base/compose/entrypoints/$template_conf" &>/dev/null &
    print_loading $! "Remove $template_conf from entrypoints"
    docker exec nginx rm -f /etc/nginx/conf.d/$conf &>/dev/null &
    print_loading $! "Remove $conf from nginx container"
    docker exec nginx nginx -s reload &>/dev/null &
    print_loading $! "Reload nginx"
    docker compose -f "$folder/docker-compose.yml" down
}

if [ $# -gt 0 ]; then
    if [[ "$1" = "all" ]]; then
        echo "Stop and kill containers from all ddeploy projects..."
        folders=$(getAll "folder")
        read -a folders < <(getAll "folder")
        for folder in "${folders[@]}"; do
            echo "  - $(basename "$folder")"
            down "$folder"
        done
    elif isWorkdir $1; then
        echo "Stop and kill containers from $(basename "$WORKDIR")..."
        down $WORKDIR
    else
        echo "$1 is not ddeploy enviorment."
        exit 1
    fi
else
    if ! isWorkdir "$PWD"; then
        echo "$WORKDIR is not ddeploy enviorment."
        exit 1
    else
        echo "Stop and kill containers from $(basename "$WORKDIR")..."
        down "$WORKDIR"
    fi
fi
