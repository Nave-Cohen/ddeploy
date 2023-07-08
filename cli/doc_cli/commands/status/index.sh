#!/bin/bash

function updateCommit(){
    REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
    GIT_REF="https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH"
    commit=$(curl -s --request GET "$GIT_REF" | jq -c . | jq -r '.object.sha | tostring | rtrimstr("\n")')
    sed -E "s/(COMMIT=).*/\1$commit/" "$workdir/.runner.env" > "$workdir/.runner.env.tmp"
    mv "$workdir/.runner.env.tmp" "$workdir/.runner.env"
}

updateCommit
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
printf -- "-%.0s" $(seq 1 $((55 - length)))
echo

printf "%-20s %-20s %-20s %-15s %-20s\n" "HTTP Status" "Docker Status" "Last build" "Branch" "Commit"
printf "%-20s %-20s %-20s %-15s %-20s\n" "$http_status" "$docker_status" "$created" "$BRANCH" "$COMMIT"

#Services
echo 
printf -- "-%.0s" {1..45}
printf " Services "
printf -- "-%.0s" {1..45}
echo 
container_info=$(docker ps --format "{{.Names}}|{{.Image}}|{{.Status}}")
printf "%-20s %-30s %-20s\n" "Name" "Image" "Status"
IFS=$'\n'
for info in $container_info; do
  IFS='|' read -r name image status <<< "$info"
  printf "%-20s %-30s %-20s\n" "$name" "$image" "$status"
done