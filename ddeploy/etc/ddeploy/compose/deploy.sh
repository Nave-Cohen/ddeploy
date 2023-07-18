#!/bin/bash

cleanup() {
    # Perform cleanup tasks here
    echo "Performing cleanup tasks..."
    # Stop Docker Compose
    docker compose down
    # Additional cleanup steps if needed
}

# Trap termination signals
trap 'cleanup' SIGINT SIGTERM

start_service() {
    # Start Docker Compose and other necessary tasks
    docker compose up >/var/log/ddeploy/nginx.log 2>&1 &
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Act based on the output
        if [[ $line == *"[emerg]"* ]]; then
            domain_name=$(echo "$line" | sed -n 's/.*"\(\/etc\/letsencrypt\/live\/\([^\/]*\)\/fullchain.pem\)".*/\2/p')
            rm entrypoints/nginx_templates/"$domain_name".conf
            systemctl restart ddeploy.service
        fi
        read -t 0.1 -r -s
    done < <(tail -f /var/log/ddeploy/nginx.log)
}

stop_service() {
    # Stop Docker Compose and perform any cleanup tasks
    docker compose down
    # Additional cleanup steps if needed
}
if [[ "$1" == "stop" ]]; then
    stop_service
else
    start_service
fi
