
base=/etc/ddeploy/compose

create_nginx(){
    file="$(basename "$1").conf.template"
    acme="$(basename "$1")-acme.conf.template"
    envsubst '$DOMAIN,$BACKEND_IP,$BACKEND_IP,$BACKEND_PORT' < $base/templates/nginx.conf > $base/entrypoints/conf/$file
    envsubst '$DOMAIN,$BACKEND_IP,$BACKEND_IP,$BACKEND_PORT' < $base/templates/nginx-acme.conf > $base/entrypoints/acme/$acme
}

echo "Stop reverse_proxy_http to release port 80"
docker compose -f "$base/docker-compose.yml" stop reverse_proxy_http &> /dev/null
echo "Build project and certficate domain on port 80"
docker compose -f "$WORKDIR/docker-compose.yml" build --build-arg GIT="$GIT"
docker compose -f "$WORKDIR/docker-compose.yml" up -d

if [ $? -eq 0 ]; then
    create_nginx "$DOMAIN"
    echo "Stop and remove nginx-acme & certbot"
    docker compose -f "$WORKDIR/docker-compose.yml" rm certbot nginx-acme -fs &> /dev/null
    echo "Restart reverse_proxy_https [443] & reverse_proxy_http [80]"
    docker compose -f "$base/docker-compose.yml" restart &> /dev/null
    echo "Deploy finish"
fi