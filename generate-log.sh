#!/bin/bash

# Define the output file
OUTPUT_FILE="CHANGELOG-TEMP.md"
VERSION="$1"
# Get the latest tag
LATEST_TAG=$(git describe --tags --abbrev=0)

# Write the header to the README.md file
echo "# Changelog v$VERSION" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Function to generate changelog sections
function generate_section() {
    local section_title="${!#}"
    local prefixes=("${@:1:$#-1}")

    : > temp_log.txt

    for prefix in "${prefixes[@]}"; do
        if [ -n "$prefix" ]; then
            git log $LATEST_TAG..HEAD --pretty=format:"%s ([%h](https://github.com/${GITHUB_REPOSITORY}/commit/%h))" | grep -E "^(${prefix}):" | sed "s/${prefix}://g" >> temp_log.txt
        fi
    done

    if [ -s temp_log.txt ]; then
        echo "## ${section_title}" >> $OUTPUT_FILE
        while IFS= read -r line
        do
            echo "  * $line" >> $OUTPUT_FILE
        done < temp_log.txt
        echo "" >> $OUTPUT_FILE
    fi
    rm temp_log.txt
}

generate_section "fix" "bugfix" "bug" "🐛 Bug Fixes"
generate_section "feat" "feature" "🚀 New Features"
generate_section "chore" "maintain" "🛠 Maintenance"
generate_section "cmd" "commands" "💻 Commands"

echo "CHANGELOG.md has been generated with the specified log entries."

# Read the entire content of CHANGELOG.md
changelog=$(cat $OUTPUT_FILE)

echo "changelog=$changelog" >> $GITHUB_OUTPUT
