#!/bin/bash


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

. ./tests/shunit2
