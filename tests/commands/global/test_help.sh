#!/bin/bash
set -e

function test_help {
    actual="$(ddeploy help)"
    expected="$(cat /etc/ddeploy/commands/global/help/_help)"

    assertEquals "main help menu" "$actual" "$expected"
}

function test_down_help {
    actual="$(ddeploy help down)"
    expected="$(cat /etc/ddeploy/commands/global/down/_help)"

    assertEquals "down help menu" "$actual" "$expected"
}

function test_domains_help {
    actual="$(ddeploy help domains)"
    expected="$(cat /etc/ddeploy/commands/domains/_help)"

    assertEquals "domains help menu" "$actual" "$expected"
}

function test_init_help {
    actual="$(ddeploy help init)"
    expected="$(cat /etc/ddeploy/commands/global/init/_help)"

    assertEquals "init help menu" "$actual" "$expected"
}
function test_ls_help {
    actual="$(ddeploy help ls)"
    expected="$(cat /etc/ddeploy/commands/global/ls/_help)"

    assertEquals "ls help menu" "$actual" "$expected"
}
function test_repo_help {
    actual="$(ddeploy help repo)"
    expected="$(cat /etc/ddeploy/commands/repo/_help)"

    assertEquals "repo help menu" "$actual" "$expected"
}

function test_status_help {
    actual="$(ddeploy help status)"
    expected="$(cat /etc/ddeploy/commands/status/_help)"

    assertEquals "status help menu" "$actual" "$expected"
}
function test_token_help {
    actual="$(ddeploy help token)"
    expected="$(cat /etc/ddeploy/commands/token/_help)"

    assertEquals "token help menu" "$actual" "$expected"
}
function test_up_help {
    actual="$(ddeploy help up)"
    expected="$(cat /etc/ddeploy/commands/up/_help)"

    assertEquals "up help menu" "$actual" "$expected"
}

. ./tests/shunit2
