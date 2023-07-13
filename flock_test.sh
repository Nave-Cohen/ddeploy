#!/bin/bash

lock_file="/tmp/test.lock"
exec 9>"$lock_file"

if flock -n 9; then
    echo "Lock acquired successfully"
    sleep 10
    echo "Lock released"
else
    echo "Failed to acquire lock"
    exit 1
fi
