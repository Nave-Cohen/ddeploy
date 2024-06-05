#!/bin/bash

function clean_deployed {
    local deploys_json="/etc/ddeploy/configs/deploys.json"
    local workdir="$SHUNIT_TMPDIR"
    new_json=$(jq --arg wd "$workdir" '[.[] | select(.folder != $wd)]' $deploys_json)
    echo "$new_json" > "$deploys_json"
}
function add_env_argument {
    var="$1"
    value="$2"
    sed -i "s/^${var}=.*/${var}=${value}/" ./.ddeploy.env
}

function test_no_image {
    output=$(ddeploy up)
    actual="Error: IMAGE must be defined in .ddeploy.env file"
    assertEquals "IMAGE not defined" "$output" "$actual"
}

function test_set_image {
    add_env_argument "IMAGE" "node:20-alpine"
    output=$(ddeploy up)
    actual="Error: IMAGE must be defined in .ddeploy.env file"
    assertNotEquals "IMAGE not defined" "$output" "$actual"
}

function test_no_build {
    output=$(ddeploy up)
    actual="Error: BUILD must be defined in .ddeploy.env file"
    assertEquals "BUILD not defined" "$output" "$actual"
}

function test_set_build {
    add_env_argument "BUILD" "'npm install'"
    output=$(ddeploy up)
    actual="Error: BUILD must be defined in .ddeploy.env file"
    assertNotEquals "BUILD not defined" "$output" "$actual"
}

function test_no_run {
    output=$(ddeploy up)
    actual="Error: RUN must be defined in .ddeploy.env file"
    assertEquals "RUN not defined" "$output" "$actual"
}

function test_set_run {
    add_env_argument "RUN" "'npm run'"
    output=$(ddeploy up)
    actual="Error: RUN must be defined in .ddeploy.env file"
    assertNotEquals "RUN not defined" "$output" "$actual"
}

function test_no_domains {
    output=$(ddeploy up)
    actual="Error: DOMAINS must be defined in .ddeploy.env file"
    assertEquals "DOMAINS not defined" "$output" "$actual"
}

function test_set_domains {
    add_env_argument "DOMAINS" "'www.example.com example.com'"
    output=$(ddeploy up)
    actual="Error: DOMAIN must be defined in .ddeploy.env file"
    assertNotEquals "DOMAINS not defined" "$output" "$actual"
}

function setUp {
    cd $SHUNIT_TMPDIR
}

function oneTimeSetUp {
    cd $SHUNIT_TMPDIR
    no_out=$(ddeploy init https://github.com/Nave-Cohen/ddeploy.git main)
}
function oneTimeTearDown {
    clean_deployed
}
. ./tests/shunit2
