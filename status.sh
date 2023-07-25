#!/bin/bash
export base="/etc/ddeploy"
source /etc/ddeploy/helpers/json.sh
source /etc/ddeploy/helpers/enviorment.sh

pStatus() {
    WORKDIR="$1"
    load_vars "$WORKDIR"

    http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN")
    if [[ $http_status == "200" || $http_status == "302" ]]; then
        http_status="200/OK"
    else
        http_status="$http_status/ERROR"
    fi

    docker_info=$(docker inspect -f '{{.State.Status}} - {{.State.StartedAt}}' "app-$NAME") &>/dev/null
    status=$(echo "$docker_info" | awk -F ' - ' '{print $1}')
    started_at=$(echo "$docker_info" | awk -F ' - ' '{print $2}')

    if [[ -z $status ]]; then
        status="Not running"
        started_at="N/A"
    else
        started_at=$(date -d "$started_at" +"%d-%m-%Y %H:%M")
    fi

    echo "$http_status,$status,$started_at,$BRANCH,$COMMIT\n"
}

project() {
    folder="$1"
    pStatus "$folder"
    output=$(pStatus "$folder")
    output="HTTP Status,Docker status,Last Build,Branch,Commit\n$output"
    echo -e $output | column -t -s ','
}
ls() {
    folders=$(getAll "folder")
    read -a folders < <(getAll "folder")
    for folder in "${folders[@]}"; do
        output+="$(basename "$folder"),$(pStatus "$folder")"
    done
    output="Project,HTTP Status,Docker status,Last Build,Branch,Commit\n$output"
    echo -e $output | column -t -s ','
}
