#!/bin/bash

end_with() {
    local str="$1"
    local sub="$2"
    if [[ "$content" == *"$str" ]]; then
        return 0
    fi
    return 1
}
start_with() {
    local str="$1"
    local sub="$2"
    if [[ "$str" = "$sub"* ]]; then
        return 0
    fi
    return 1
}
contain() {
    local str="$1"
    local sub="$2"
    if [[ "$str" == *"$sub"* ]]; then
        return 0
    fi
    return 1
}

replace_pad() {
    local content="$1"
    local old_str="$2"
    local new_str="$3"
    local spaces_to_pad=$((${#new_str} - ${#old_str}))

    # Pad the new string with spaces to match the length of the original string
    if ((spaces_to_pad > 0)) && ! end_with "$content" "$old_str"; then
        old_str="$old_str$(printf '%*s' "$spaces_to_pad" '')"
    fi

    # Replace the part of the content string with the padded new string
    echo "$content" | sed "s/$old_str/$new_str/"
}

replace() {
    local content="$1"
    local old_str="$2"
    local new_str="$3"
    echo "$content" | sed "s/$old_str/$new_str/"
}
replace_all_pad() {
    local content="$1"
    local replace="$2"

    # Convert the replace string into an array using '|' as the delimiter
    IFS="| " read -ra replacements <<<"$replace"

    # Ensure the number of replacements is even (each replacement consists of a pair)
    if ((${#replacements[@]} % 2 != 0)); then
        echo "Error: Invalid number of replacements."
        return 1
    fi

    # Perform the replacements
    for ((i = 0; i < ${#replacements[@]}; i += 2)); do
        to_replace="${replacements[i]}"
        replacement="${replacements[i + 1]}"

        # Calculate the spaces to pad
        spaces_to_pad=$((${#replacement} - ${#to_replace}))

        # Pad the new string with spaces to match the length of the original string
        if ((spaces_to_pad > 0)) && [[ ! "$content" == *"$to_replace" ]]; then
            to_replace="$to_replace$(printf '%*s' "$spaces_to_pad" '')"
        fi

        # Replace the part of the content string with the padded new string
        content="${content//$to_replace/$replacement}"
    done

    echo "$content"
}

replace_all() {
    local content="$1"
    local replace="$2"

    # Convert the replace string into an array using '|' as the delimiter
    IFS="| " read -ra replacements <<<"$replace"

    # Ensure the number of replacements is even (each replacement consists of a pair)
    if ((${#replacements[@]} % 2 != 0)); then
        echo "Error: Invalid number of replacements."
        return 1
    fi

    # Perform the replacements
    for ((i = 0; i < ${#replacements[@]}; i += 2)); do
        to_replace="${replacements[i]}"
        replacement="${replacements[i + 1]}"
        content="${content//$to_replace/$replacement}"
    done

    echo "$content"
}

remove() {
    local content="$1"
    shift

    for i in "$@"; do
        content="${content//$i/}"
    done

    # Remove leading and trailing spaces and replace multiple spaces with a single space
    content=$(echo "$content" | sed -E 's/ +/ /g;s/^[[:space:]]*//;s/[[:space:]]*$//')

    echo "$content"
}

extract() {
    str="$1"
    sep="$2"
    num="$3"
    echo "$str" | cut -d"$sep" -f$num
}
