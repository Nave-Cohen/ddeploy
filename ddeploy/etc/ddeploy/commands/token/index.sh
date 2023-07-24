#!/bin/bash
base=/etc/ddeploy

if [ $# -lt 1 ]; then
    echo "doc token [token]"
    exit 5
fi
source /etc/ddeploy/helpers/token.sh
source "/etc/ddeploy/helpers/repo.sh"
set_token "$1"

commit=$(fetchCommit "$PWD")
if [ -n "$commit" ]; then
    echo "Token is added successfully"
else
    rm $path
    echo "Token is not valid"
fi
