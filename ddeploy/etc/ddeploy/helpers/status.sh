#!/usr/bin/env bash

source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/json.sh
source /etc/ddeploy/helpers/enviorment.sh

status() {
    WORKDIR="$1"
    load_vars "$WORKDIR"

    http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN")
    if [[ $http_status == "200" || $http_status == "302" ]]; then
        http_status="200/OK"
    else
        http_status="$http_status/ERROR"
    fi

    # Get Docker status
    status=$(docker compose ls | awk -v project="$NAME" '$1 == project {print $2}')
    if [[ -z "$status" ]]; then
        status="Not running"
        started_at="N/A"
    else
        started_at=$(date -d "$started_at" +"%d-%m-%Y %H:%M")

    fi

    echo "$http_status,$status,$started_at,$BRANCH,$COMMIT\n"
}

projectStatus() {
    folder="$1"
    output=$(status "$folder")
    output="HTTP Status,Docker status,Last Build,Branch,Commit\n$output"
    echo -e $output | column -t -s ','
}

servicesStatus() {
    # Services status
    # Print the title with underline

    echo

    base='{{.Names}}\t{{.Image}}\t{{.Status}}\t'
    content=$(docker container ls --all --filter label=com.docker.compose.project="$NAME" --format "table $base")
    echo -e "$content"
}

webStatus() {
    # Get HTTP status

    echo
    output="Domain,Status\n"
    for domain in $DOMAINS; do
        http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN")
        if [[ $http_status == "200" || $http_status == "302" ]]; then
            http_status="200/OK"
        else
            http_status="$http_status/ERROR"
        fi
        output+="$domain,$http_status\n"
    done
    echo -e $output | column -t -s ','
}
