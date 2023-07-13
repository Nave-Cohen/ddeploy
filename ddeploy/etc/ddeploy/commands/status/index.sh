#!/usr/bin/env bash
source /etc/ddeploy/helpers/printer.sh
source /etc/ddeploy/helpers/status.sh

# Print title
print_title 50 "$(basename $WORKDIR)" 67
# Print project headers
printf "%-20s %-20s %-20s %-15s %-20s\n" "HTTP Status" "Docker Status" "Last build" "Branch" "Commit"

# Print project status
projectStatus "$WORKDIR"

# Print the status of project services
servicesStatus "$WORKDIR"
