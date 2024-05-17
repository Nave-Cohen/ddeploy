#!/bin/bash
set -e

function fileExist {
    filename=$1
    echo "[ -f '${SHUNIT_TMPDIR}/${filename}' ]"
}

function test_not_enviorment {
    actual="$(ddeploy command)"
    expected="$(basename $PWD) is not a runner environment"
    assertEquals "not a runner enviorment" "$actual" "$expected"
}

function test_no_arguments {
    actual="$(ddeploy init)"
    expected="[ERROR] - ddeploy init [github url] [branch name]"
    assertEquals "no argument added" "$actual" "$expected"
}

function test_no_github_url {
    actual="$(ddeploy init false_url)"
    expected="[ERROR] - ddeploy init [github url] [branch name]"
    assertEquals "no github url argument" "$actual" "$expected"
}

function test_no_branch {
    actual="$(ddeploy init https://github.com/Nave-Cohen/ddeploy.git)"
    expected="[ERROR] - ddeploy init [github url] [branch name]"
    assertEquals "no branch argument" "$actual" "$expected"
}

function test_non_existing_github_url {
    actual="$(ddeploy init https://github.com/Nave-Cohen/ddeloy.git main)"
    expected="[ERROR] - github url or branch-name are wrong."
    assertEquals "github url is not exist" "$actual" "$expected"
}

function test_non_existing_branch {
    actual="$(ddeploy init https://github.com/Nave-Cohen/ddeploy.git non_exist)"
    expected="[ERROR] - github url or branch-name are wrong."
    assertEquals "github branch is not exist" "$actual" "$expected"
}

function test_init_success {
    output=$(ddeploy init https://github.com/Nave-Cohen/ddeploy.git main)
    actual=$(echo "$output" | grep -q "Runner environment initialized successfully.")
    assertTrue "Initialization message not found" '${actual}'
}

function test_init_files_created {
    files=("app/Dockerfile" "docker-compose.yml" "mongo-compose.yml" ".ddeploy.env" "entrypoint/cert.sh")
    for file in "${files[@]}"; do
        actual=$(fileExist "$file")
        assertTrue "$file is missing" "$actual"
    done
}

function setUp {
    cd $SHUNIT_TMPDIR
}

. ./tests/shunit2
