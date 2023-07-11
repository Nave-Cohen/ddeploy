#!/bin/bash
base=/etc/ddeploy/compose

create_nginx(){
    file="$(basename "$1").conf.template"
    acme="$(basename "$1")-acme.conf.template"

    cp $base/templates/nginx.conf $base/entrypoints/$file
    cp $base/templates/nginx-acme.conf $base/entrypoints/$acme

    envsubst < $base/entrypoints/$file
    envsubst < $base/entrypoints/$acme
}

json_data="$base/configs/deploys.json"
while IFS= read -r line; do
    folder=$(echo "$line" | jq -r '.folder')
    export $(grep -v '^#' "$folder/.ddeploy.env" | xargs)
    create_nginx "$folder"
done < <(jq -c '.[]' "$json_data")

cd $base
docker compose up
