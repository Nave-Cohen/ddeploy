#!/usr/bin/env bash

# prints colored text
print() {
  local text=$1
  local color=$2
  local extra_text=${3:-""}
  local type="$extra_text"
  # Check the type of formatting required
  if [ "$type" == "b" ]; then
    type=1
  elif [ "$type" == "u" ]; then
    type=4
  elif [ "$type" == "b&u" ]; then
    type="1;4"
  else
    type=0
  fi

  # Set the color based on the provided type
  if [ "$color" == "info" ]; then
    COLOR="$type;34m"
  elif [ "$color" == "succ" ]; then
    COLOR="$type;32m"
  elif [ "$color" == "warn" ]; then
    COLOR="$type;33m"
  elif [ "$color" == "err" ]; then
    COLOR="$type;31m"
  else #default color
    COLOR="0m"
  fi

  STARTCOLOR="\e[$COLOR"
  ENDCOLOR="\e[0m"

  # Print the text with the specified formatting
  printf "$STARTCOLOR$1$ENDCOLOR $extra_text"
}

printn() {
  # Call the print function and add a newline character
  print "$@"
  echo
}

print_loading() {
  pid=$1
  msg=$2
  frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  len=${#frames[@]}
  i=0

  # Loop until the process is completed
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "${frames[i]}" "$msg"
    sleep 0.2
    i=$(((i + 1) % len))
  done

  wait "$pid"
  exitCode=$?

  if [ "$exitCode" -eq 0 ]; then
    print "\r ✔ %s" "succ" "$msg"
  else
    print "\r ✘ %s" "err" "$msg"
  fi
  echo
  return "$exitCode"
}

print_nchar() {
  local char=$1
  local count=$2

  for ((i = 0; i < count; i++)); do
    printf "%s" "$char"
  done
  printf "\n"
}

print_table() {
  local num_columns=$1
  shift
  local headers=("$@")
  local content=("${headers[@]:num_columns}")

  # Calculate the width of each column
  local widths=()
  for ((i = 0; i < num_columns; i++)); do
    local max_length=${#headers[i]}
    for ((j = i; j < ${#content[@]}; j += num_columns)); do
      local content_length=${#content[j]}
      if ((content_length > max_length)); then
        max_length=$content_length
      fi
    done
    widths+=("$max_length")
  done

  # Print the header
  for ((i = 0; i < num_columns; i++)); do
    printf "%-*s" "${widths[i]}" "${headers[i]}"
    if ((i != num_columns - 1)); then
      printf "     "
    fi
  done
  printf "\n"

  # Print the content
  for ((i = 0; i < ${#content[@]}; i += num_columns)); do
    for ((j = i; j < i + num_columns; j++)); do
      printf "%-*s" "${widths[j - i]}" "${content[j]}"
      if ((j != i + num_columns - 1)); then
        printf "     "
      fi
    done
    printf "\n"
  done
}

print_title() {
  title="$1"
  padding=$2

  if [ $# -lt 2 ]; then
    width=$(tput cols)
    padding=$((width / 2 - ${#title} / 2))
    rpadding=$padding
  else
    rpadding=$3
  fi

  # Print the underline characters with green formatting
  printf '\e[4;32m%*s%s%*s\e[0m\n' "$padding" '' "$title" "$rpadding" ''
}
