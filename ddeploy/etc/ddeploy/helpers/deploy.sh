#!/usr/bin/env bash

base="/etc/ddeploy/compose"
conf="$DOMAIN.conf"
template_conf="$conf.template"
flag=0

source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/json.sh

exit_error() {
    local err_msg="$1"
    echo "Abort: Deploy $err_msg"
    if [ "$flag" -eq 1 ]; then
        rm "$base/entrypoints/nginx_templates/$template_conf" &>/dev/null
        docker exec nginx rm /etc/nginx/conf.d/$conf &>/dev/null
    fi
    docker compose -f "$WORKDIR/docker-compose.yml" down
    exit 1
}

create_nginx() {
    export SERVICE="app-$DOMAIN"

    if ! (envsubst '$DOMAIN,$SERVICE,$BACKEND_PORT' <"$base/templates/https.conf" >"$base/entrypoints/nginx_templates/$template_conf") 2>/dev/null; then
        return 1
    fi

    if ! docker cp "$base/entrypoints/nginx_templates/$template_conf" "nginx:/etc/nginx/conf.d/$conf" &>/dev/null; then
        return 1
    fi
    return 0
}
export GIT="$(getItem "$WORKDIR" git)"
export BRANCH="$(getItem "$WORKDIR" branch)"
export BACKEND_PORT="$(getItem "$WORKDIR" port)"
docker compose -f "$WORKDIR/docker-compose.yml" up --build -d

certStatus=$(docker inspect -f '{{ .State.ExitCode }}' "certbot-$DOMAIN" 2>/dev/null)

if [ "$certStatus" != "0" ]; then
    exit_error "Faild on certificate domain"
fi

printn "[+] Deploy 1/1" "info"
create_nginx "$DOMAIN" &
print_loading $! "Copy $DOMAIN.conf to nginx container"

if [ "$?" -eq 0 ]; then
    echo "Deploy ended successfully"
else
    flag=1
    exit_error "Failed to copy ${DOMAIN}.conf to nginx container"
fi
