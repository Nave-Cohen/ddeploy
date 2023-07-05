#!/bin/bash

docker_status=$(docker compose ls | awk -v project="$NAME" '$1 == project {print $2}')
if [[ -z $docker_status ]]; then
    docker_status="Not running"
fi


http_status=$(curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN)
if [ "$http_status" == "200" ] || [ "$http_status" == 302 ]; then
     http_status="200/OK"
else
    http_status="$http_status/ERROR"
fi


created=$(docker inspect -f '{{.Created}}' "$NAME-app" | date -f - +"%d-%m-%Y %H:%M")

echo "Project name: $NAME"
printf "%-20s %-20s %-20s\n" "HTTP Status" "Docker Status" "Last build"
printf "%-20s %-20s %-20s\n" "$http_status" "$docker_status" "$created"