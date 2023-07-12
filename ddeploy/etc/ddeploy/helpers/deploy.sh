
base=/etc/ddeploy/compose
export stderr=$(mktemp)

source /etc/ddeploy/helpers/printer.sh
create_nginx(){
    https="$(basename "$1")-https.conf.template"
    envsubst '$DOMAIN,$BACKEND_IP,$BACKEND_IP,$BACKEND_PORT' < $base/templates/https.conf > $base/entrypoints/https/$https
}

docker compose -f "$WORKDIR/docker-compose.yml" up -d

if [ $? -eq 0 ]; then
    printn "[+] Ending handle certificate " "info"
    (create_nginx "$DOMAIN") &
    print_loading $! "Create nginx_http and nginx_https conf files" "$stderr"
    (docker compose -f "$WORKDIR/docker-compose.yml" rm certbot -fs &> "$stderr") &
    print_loading $! "Stop and remove certbot" "$stderr"
    docker compose -f "$base/docker-compose.yml" up -d

fi