#!/bin/bash

get_token() {
    hash="$(cat "$hash_path")"
    if [ ! -f $token_path ]; then
        return 1
    fi
    token="$(cat "$token_path" | openssl aes-256-cbc -d -a -pass pass:$hash -pbkdf2)"
    echo $token
    return 0
}

set_token() {
    hash="$(cat "$hash_path")"
    token="$1"
    enc_token="$(echo $token | openssl aes-256-cbc -a -salt -pass pass:$hash -pbkdf2)"
    echo "$enc_token" >$token_path
}
