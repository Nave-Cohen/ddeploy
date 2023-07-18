conf="$DOMAIN.conf"
template_conf="$conf.template"
rm "$base/entrypoints/nginx_templates/$template_conf" &>/dev/null
docker exec nginx rm /etc/nginx/conf.d/$conf &>/dev/null
docker compose -f "$WORKDIR/docker-compose.yml" down
