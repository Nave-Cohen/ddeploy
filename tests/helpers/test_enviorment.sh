#!/bin/bash

function clean_deployed {
    local deploys_json="/etc/ddeploy/configs/deploys.json"
    local workdir="$SHUNIT_TMPDIR"
    new_json=$(jq --arg wd "$workdir" '[.[] | select(.folder != $wd)]' $deploys_json)
    echo "$new_json" > "$deploys_json"
}

function test_no_image {
    output=$(ddeploy up)
    actual="Error: IMAGE must be defined in .ddeploy.env file"
    assertEquals "IMAGE not defined" "$output" "$actual"
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
