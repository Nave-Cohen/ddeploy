#!/usr/bin/env bash

# Test the case where no command is set
test_no_command_set() {
  result=$(sudo ddeploy)
  expected="[ERROR] No command set"
  assert_equals "$expected" "$result"
}

# Test the case where the current directory is not a runner environment
test_not_runner_environment() {
  result=$(sudo ddeploy some_command)
  expected="$(basename "$PWD") is not a runner environment"
  assert_equals "$expected" "$result"
}

# Test the "init" command
test_init_command() {
  result=$(sudo ddeploy init url branch)
  expected="[ERROR] - github url or branch-name are wrong."
  assert_equals "$expected" "$result"
}

# Test the "init" command
test_init_fail_branch_command() {
  result=$(sudo ddeploy init https://github.com/Nave-Cohen/docker-web.git branch)
  expected="[ERROR] - github url or branch-name are wrong."
  assert_equals "$expected" "$result"
}

# Test the "init" command
test_init_fail_url_command() {
  result=$(sudo ddeploy init url main)
  expected="[ERROR] - github url or branch-name are wrong."
  assert_equals "$expected" "$result"
}

# Test the "init" command
test_init_valid_command() {
  sudo ddeploy init https://github.com/Nave-Cohen/ddeploy.git main >/dev/null 2>&1 &
  result=$(if [[ -f .ddeploy.env ]]; then echo "true"; else echo "false"; fi)
  expected="true"
  assert_equals "$expected" "$result"
}


remove_enviorment(){
    rm .sudo ddeploy.env
    rm -r app
    rm -r entrypoint
    rm -r docker-compose.yml
}

# Helper function to assert equality between expected and actual values
assert_equals() {
  local expected="$1"
  local actual="$2"
  if [[ "$expected" != "$actual" ]]; then
    echo "Assertion failed: Expected '$expected', but got '$actual'"
    exit 1
  fi
}

# Helper function to assert the exit code of the script
assert_exit_code() {
  local expected_exit_code="$1"
  local actual_exit_code="$?"
  if [[ "$expected_exit_code" -ne "$actual_exit_code" ]]; then
    echo "Assertion failed: Expected exit code '$expected_exit_code', but got '$actual_exit_code'"
    exit 1
  fi
}

# Run all the tests
run_tests() {
  test_no_command_set
  test_not_runner_environment
  test_init_command
  test_init_fail_branch_command
  test_init_fail_url_command
  test_init_valid_command
  remove_enviorment
}

# Execute the test suite
run_tests