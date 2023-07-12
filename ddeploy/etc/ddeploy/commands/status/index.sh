#!/usr/bin/env bash
NAME=$(basename "$WORKDIR")
source /etc/ddeploy/helpers/printer.sh

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

# Print the title with underline
print_title 50 "$NAME" 67

# Set the header and content for the table
header=("Domain" "HTTP Status" "Docker Status" "Last build" "Branch" "Commit")
content=("$DOMAIN" "$http_status" "$docker_status" "$created" "$BRANCH" "$commit")

# Print the table
print_table ${#header[@]} "${header[@]}" "${content[@]}"

echo

# Services
# Print the title with underline
print_title 28 "Services"

# Get container information
container_info=$(docker ps --format "{{.Names}}|{{.Image}}|{{.Status}}")
header=("Name" "Image" "Status")

IFS=$'\n'
content=()
for info in $container_info; do
    IFS='|' read -r name image status <<< "$info"
    content+=("$name" "$image" "$status")
done

# Print the table
print_table ${#header[@]} "${header[@]}" "${content[@]}"
