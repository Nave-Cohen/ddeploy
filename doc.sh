#!/bin/bash

export $(grep -v '^#' .runner | xargs)
if [ -z "$GIT" ]; then
    echo "GIT=*** must be defined in .runner file"
    exit 1
elif  [ -z "$DOMAIN" ]; then
    echo "DOMAIN=*** must be defined in .runner file"
    exit 1
elif   [ -z $BRANCH ]; then
    echo "BRANCH=*** must be defined in .runner file"
    exit 1
fi

REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
export GIT_REF=https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH


workdir="$PWD"
if [ -f "$workdir/.runner" ]; then
    bash $workdir/bin/fetch.sh
    bash $workdir/bin/$1.sh
else
    echo "$workdir is not a runner enviorment"
fi
