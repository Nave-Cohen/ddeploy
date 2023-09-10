#!/usr/bin/env bash

import "printer"

status() {
    WORKDIR="$1"

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
        container_started_at=$(docker inspect --format='{{.State.StartedAt}}' "app-$NAME")
        desired_time_zone='Asia/Jerusalem'

        # Extract the date and time components from the container_started_at string
        date_part="${container_started_at:0:10}"
        time_part="${container_started_at:11:8}"

        # Convert the UTC timestamp to the desired time zone
        started_at=$(TZ="$desired_time_zone" date --date="$date_part $time_part" +'%Y-%m-%d %H:%M:%S')

    fi

    repo=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
    echo "$NAME,$http_status,$status,$started_at,$repo,$BRANCH,$COMMIT\n"
}

projectStatus() {
    folders="$1"
    output="Project,HTTP Status,Docker status,Created,User/Repo,Branch,Commit\n"
    IFS=' ' # Set the Internal Field Separator to space

    for folder in $folders; do
        source "$scripts/enviorment.sh" "$folder"
        output+="$(status "$folder")\n"
    done <<<"$folders"
    echo -e "$output" | column -t -s ','
}
