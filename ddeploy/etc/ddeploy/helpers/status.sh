#!/usr/bin/env bash

source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/json.sh

projectStatus() {
    #Project status
    folder="$1"
    meta="$2"

    set -a
    . "$folder/.ddeploy.env"
    set +a
    local NAME=$(basename "$folder")
    commit=$(getItem "$folder" "commit")
    branch=$(getItem "$folder" "branch")
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
    if [ "$meta" == "all" ]; then
        printf "%-20s %-20s %-20s %-20s %-15s %-20s\n" "$NAME" "$http_status" "$docker_status" "$created" "$branch" "$commit"
    else
        printf "%-20s %-20s %-20s %-15s %-20s\n" "$http_status" "$docker_status" "$created" "$branch" "$commit"
    fi
}

servicesStatus() {
    # Services status
    # Print the title with underline
    NAME=$(basename "$1")
    print_title 25 "Services"

    base='{{.Names}}\t{{.Image}}\t{{.Status}}\t'
    content=$(docker container ls --all --filter label=com.docker.compose.project="$NAME" --format "table $base")
    echo -e "$content"
}
