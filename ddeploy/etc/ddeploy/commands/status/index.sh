#!/usr/bin/env bash
import "status"
import "string"

# Print project status
projectStatus "$WORKDIR"

echo
base='{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
content=$(docker container ls --all --filter label=com.docker.compose.project="$NAME" --format "table $base")
# Create an associative array to hold the replacements

content=$(replace_all_pad "$content" "NAMES|Container IMAGE|Image STATUS|Status PORTS|Port")
echo -e "$content"
