#!/usr/bin/env bash
import "printer"

conf="$NAME.conf"
template_conf="$conf.template"

print_title "Start deployment $(date "+%d-%m-%Y %H:%M")" >>$deploy_log

set -e
# Set the trap to call the ignore_sigint function for SIGINT (Ctrl+C)

exit_error() {
    trap '' SIGINT
    status="$1"
    command="$2"
    line="$3"
    echo -e "Abort Deploy:\n $command - [line $line | $status]"
    $command_line "down" "$WORKDIR"
    exit 1
}

trap 'exit_error $? "$BASH_COMMAND" $LINENO' ERR
trap 'exit_error 1 "User aborted" $LINENO' SIGINT

create_nginx() {
    export DOMAIN_NAME="$(echo $DOMAIN | cut -d '.' -f1)"
    templates="$base/compose/templates/https.conf"
    entrypoints=$base/compose/entrypoints/$template_conf

    envsubst '$DOMAIN,$NAME,$DOMAINS,$DOMAIN_NAME,$PORT' <"$templates" >"$entrypoints"

    docker cp "$entrypoints" "nginx:/etc/nginx/conf.d/$conf" >>$deploy_log 2>&1

    docker exec nginx nginx -t &>/dev/null
}

# Run 'docker-compose' command to bring up containers in detached mode in the background
docker compose -f "$WORKDIR/docker-compose.yml" up -d

exec 1> >(tee -a "$deploy_log")
exec 2>>"$error_log"

certStatus=$(docker inspect -f '{{ .State.ExitCode }}' "certbot-$NAME")

printn "[+] Deploy 1/1" "info"
create_nginx &
print_loading $! "Copy $NAME.conf to nginx container"

docker exec nginx nginx -s reload >>"$deploy_log" 2>&1

echo "Deploy ended successfully" >>$deploy_log
print_title "End deploment" >>$deploy_log
