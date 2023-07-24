#!/bin/bash

base=/etc/ddeploy
path="$base/configs/token"
hash="$(cat $base/.hash)"

get_token() {
    if [ ! -f $path ]; then
        return 1
    fi
    token="$(cat $path | openssl aes-256-cbc -d -a -pass pass:$hash -pbkdf2)"
    echo $token
    return 0
}

set_token() {
    token="$1"
    enc_token="$(echo $token | openssl aes-256-cbc -a -salt -pass pass:$hash -pbkdf2)"
    echo "$enc_token" >$path
}
