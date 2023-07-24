#!/usr/bin/env bash

log_file="/var/log/ddeploy/deploy.log"

base="/etc/ddeploy/compose"
conf="$NAME.conf"
template_conf="$conf.template"

source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/json.sh

exit_error() {
    trap '' SIGINT
    local err_msg="$1"
    echo "Abort: Deploy $err_msg"
    /usr/local/bin/ddeploy "down" "$WORKDIR"
    exit 1
}

trap 'exit_error "User aborted"' SIGINT

create_nginx() {
    export DOMAIN_NAME="$(echo $DOMAIN | cut -d '.' -f1)"
    if ! (envsubst '$DOMAIN,$NAME,$DOMAINS,$DOMAIN_NAME,$PORT' <"$base/templates/https.conf" >"$base/entrypoints/$template_conf"); then
        return 1
    fi

    if ! docker cp "$base/entrypoints/$template_conf" "nginx:/etc/nginx/conf.d/$conf"; then
        return 1
    fi
    if ! docker exec nginx nginx -t; then
        return 1
    fi
    return 0
}

docker compose -f "$WORKDIR/docker-compose.yml" up --build -d

exec 2>>$log_file

if [ "$?" != "0" ]; then
    exit_error "Faild on docker compose up --build"
fi

certStatus=$(docker inspect -f '{{ .State.ExitCode }}' "certbot-$NAME")
if [ "$certStatus" != "0" ]; then
    exit_error "Faild on certificate domain"
fi

printn "[+] Deploy 1/1" "info"
create_nginx &
print_loading $! "Copy $NAME.conf to nginx container"

if [ "$?" -eq 0 ]; then
    docker exec nginx nginx -s reload
    echo "Deploy ended successfully"
else
    exit_error "Failed to copy ${NAME}.conf to nginx container"
fi
