#!/bin/bash
import "repo"
import "string"
set -euo pipefail

if ! isWorkdir "$1"; then
    echo "$(basename "$1") is not a runner environment"
    exit 1
fi

set -a
WORKDIR="$1"
source "$WORKDIR/.ddeploy.env"
set +a

required_variables=("IMAGE" "BUILD" "RUN" "DOMAINS" "MAIL" "PORT" "DATABASE")
for variable in "${required_variables[@]}"; do
    if [[ -z "${!variable}" ]] || start_with "${!variable}" "#" ; then
        echo "Error: $variable must be defined in .ddeploy.env file"
        exit 1
    fi
done

if [[ $DATABASE != "MYSQL" && $DATABASE != "MONGO" ]];then
 echo "Error: DATABASE must be MONGO or MYSQL in .ddeploy.env file"
 exit 1
fi

export DOMAIN="$(echo $DOMAINS | cut -d' ' -f1)"
export CB_DOMAINS="$(echo $DOMAINS | awk '$1=$1' FS=' ' OFS=' -d ')"
export GIT="$(getItem "$WORKDIR" git)"
export BRANCH="$(getItem "$WORKDIR" branch)"
export COMMIT="$(fetchCommit "$WORKDIR")" #must be after GIT and COMMIT
export NAME="$(basename "$WORKDIR")"
export SHORT_COMMIT="${COMMIT:0:10}"

set +euo pipefail
