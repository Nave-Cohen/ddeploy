#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function print_suite {
    GREEN='\033[0;32m'
    NC='\033[0m'
    suite_name=$1
    echo -e "${GREEN}** Test suite - $suite_name **${NC}"
}

print_suite "help"
$SCRIPT_DIR/commands/global/test_help.sh

print_suite "init"
$SCRIPT_DIR/commands/global/test_init.sh 

print_suite "enviorment"
$SCRIPT_DIR/helpers/test_enviorment.sh 