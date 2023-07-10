#!/usr/bin/env bash
NAME=$(basename "$WORKDIR")

commit=$(jq -r --arg folder "$WORKDIR" '.[] | select(.folder == $folder) | .commit' $base/configs/deploys.json)

# Get Docker status
docker_status=$(docker compose ls | awk -v project="$NAME" '$1 == project {print $2}')
if [[ -z $docker_status ]]; then
    docker_status="Not running"
fi

# Get HTTP status
http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN")
if [[ $http_status == "200" || $http_status == "302" ]]; then
    http_status="200/OK"
else
    http_status="$http_status/ERROR"
fi

# Get creation timestamp
created=$(docker inspect -f '{{.Created}}' "${NAME}-app" | date -f - +"%d-%m-%Y %H:%M")

# Print the information
length=${#NAME}
printf -- "-%.0s" $(seq 1 $((55 - length)))
printf " $NAME "
printf -- "-%.0s" $(seq 1 $((70 - length)))
echo

printf "%-15s %-15s %-15s %-20s %-10s %-15s\n" "Domain" "HTTP Status" "Docker Status" "Last build" "Branch" "Commit"
printf "%-15s %-15s %-15s %-20s %-10s %-15s\n" "$DOMAIN" "$http_status" "$docker_status" "$created" "$BRANCH" "$commit"

# Services
echo
printf -- "-%.0s" {1..28}
printf " Services "
printf -- "-%.0s" {1..32}
echo

container_info=$(docker ps --format "{{.Names}}|{{.Image}}|{{.Status}}")
printf "%-20s %-30s %-20s\n" "Name" "Image" "Status"

IFS=$'\n'
for info in $container_info; do
    IFS='|' read -r name image status <<< "$info"
    printf "%-20s %-30s %-20s\n" "$name" "$image" "$status"
done
