#!/bin/bash
ref=$(curl -s https://api.github.com/repos/Nave-Cohen/Web-Project/git/refs/heads/main)
ref_file=`cat ref.json`

if [ ! "$ref" == "$ref_file" ]; then
    cd ..
    docker compose build app
fi