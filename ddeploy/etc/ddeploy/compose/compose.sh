#!/usr/bin/env bash

ExitCode="running"
container_name="nginx"
docker_compose="/etc/ddeploy/compose/docker-compose.yml"

function remove_last_deployed() {
    last_deployed=$(tail -n 1 /etc/ddeploy/configs/deployed.lst)
    if [[ -n "$last_deployed" ]]; then
        ddeploy down "$last_deployed"
    fi
}

function is_running() {
    docker_id=$(docker ps -q --filter "name=$container_name")
    if [[ -n "$docker_id" ]]; then
        return 0
    else
        return 1
    fi
}



if [[ "$1" = "start" ]]; then
    docker compose -f $docker_compose up -d
    while is_running; do
        sleep 0.1
    done
    remove_last_deployed
fi
if [[ "$1" = "stop" ]]; then
    ddeploy down all
    docker compose -f $docker_compose down
fi
