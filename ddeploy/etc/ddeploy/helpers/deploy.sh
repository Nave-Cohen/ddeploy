
base=/etc/ddeploy/compose
export stderr=$(mktemp)

source /etc/ddeploy/helpers/printer.sh

create_nginx(){
    https="$DOMAIN.conf.template"
    envsubst '$DOMAIN,$BACKEND_IP,$BACKEND_IP,$BACKEND_PORT' < $base/templates/https.conf > $base/entrypoints/nginx_templates/$https
    docker cp $base/entrypoints/nginx_templates/$https nginx:/etc/nginx/conf.d/$DOMAIN.conf  2> $stderr 1> /dev/null
}

docker compose -f "$WORKDIR/docker-compose.yml" up -d
certStatus=$(docker inspect -f '{{ .State.ExitCode }}' "certbot-$DOMAIN")

if [ $certStatus -eq 0 ]; then
    printn "[+] Reconfigure nginx 1/1" "info"
    (create_nginx "$DOMAIN") &
    print_loading $! "Copy $DOMAIN.conf to nginx container" "$stderr"
fi

if [ $? -eq 0 ]; then
    echo "Deploy ended succesfully"
else
    echo "Deploy faild"
    docker compose -f "$WORKDIR/docker-compose.yml" down
fi