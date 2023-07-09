#!/bin/bash

exec > "/var/log/ddeploy/cleaner.log" 2>&1
json_data="/etc/ddeploy/configs/deploys.json"
filtered_json="["

while IFS= read -r line; do
    folder=$(echo "$line" | jq -r '.folder')
    if [ ! -d "$folder" ] || [ ! -f "$folder/.ddeploy.env" ]; then
        echo "$(basename "$folder") removed because .ddeploy.env not found or folder removed"
        continue
    fi
    filtered_json="$filtered_json$line,"
done < <(jq -c '.[]' "$json_data")

filtered_json="${filtered_json%,}"  # Remove the trailing comma
filtered_json="$filtered_json]"

final_json=$(echo "$filtered_json" | jq -c .)
echo "$final_json" > "$json_data" 
