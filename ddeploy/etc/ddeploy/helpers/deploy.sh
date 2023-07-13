#!/bin/bash

base="/etc/ddeploy/compose"
conf="$DOMAIN.conf"
template_conf="$conf.template"

stderr=$(mktemp)
source /etc/ddeploy/helpers/printer.sh

exit_error() {
    local err_msg="$1"
    local phase="$2"
    echo "Abort: Deploy $err_msg"
    if [[ "$phase" == "deploy" ]]; then
        rm "$base/entrypoints/nginx_templates/$template_conf" &> /dev/null
        docker exec nginx rm /etc/nginx/conf.d/$conf &> /dev/null
    fi
    docker compose -f "$WORKDIR/docker-compose.yml" down
    exit 1
}


create_nginx() {
    set -e
    trap 'return 1' ERR
    (envsubst '$DOMAIN,$BACKEND_IP,$BACKEND_IP,$BACKEND_PORT' < "$base/templates/https.conf" > "$base/entrypoints/nginx_templates/$template_conf") 2> /dev/null
    docker cp "$base/entrypoints/nginx_templates/$template_conf" "nginx:/etc/nginx/conf.d/$conf" &> /dev/null
    return 0
}


docker compose -f "$WORKDIR/docker-compose.yml" up -d

certStatus=$(docker inspect -f '{{ .State.ExitCode }}' "certbot-$DOMAIN" 2> /dev/null)

if [ "$certStatus" != "0" ]; then
    exit_error "Failed to check Certbot status" "certbot"
fi

printn "[+] Deploy 1/1" "info"
create_nginx "$DOMAIN" &
print_loading $! "Copy $DOMAIN.conf to nginx container"

if [ "$?" -eq 0 ]; then
    echo "Deploy ended successfully"
else
    exit_on_error "Failed to copy ${DOMAIN}.conf to nginx container" "deploy"
fi

