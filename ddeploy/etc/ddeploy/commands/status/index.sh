#!/usr/bin/env bash
source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/status.sh

print_title "$NAME"

# Print project status
projectStatus "$WORKDIR"

# Print the status of project services
servicesStatus "$WORKDIR"

webStatus "$WORKDIR"
