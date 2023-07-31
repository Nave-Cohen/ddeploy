#!/bin/bash

import "token"
import "repo"
import "string"

read_secret() {
    local password=""
    local char

    echo -n "Enter token: "

    while IFS= read -s -n 1 char; do
        # Break the loop when Enter is pressed
        if [[ $char == $'\0' ]]; then
            break
        fi

        # Handle backspace (remove last character from the password)
        if [[ $char == $'\177' ]]; then
            if [ -n "$password" ]; then
                password=${password%?}
                echo -en "\b \b" # Erase the last asterisk
            fi
        else
            password+=$char
            echo -n "*"
        fi
    done

    echo # Move to a new line after the user input
    export "$1"="$password"
}

read_secret token

set_token "$token"

commit=$(fetchCommit)

if [ -n "$commit" ]; then
    echo "Token is added successfully"
else
    rm $token_path
    echo "Token is not valid"
fi
