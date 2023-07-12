#!/bin/bash

# prints colored text
print () {
    # Check the type of formatting required
    if [ "$3" == "b" ]; then
        type=1
    elif [ "$3" == "u" ]; then
        type=4
    elif [ "$3" == "b&u" ]; then
        type="1;4"
    else
        type=0
    fi
    
    # Set the color based on the provided type
    if [ "$2" == "info" ] ; then
        COLOR="$type;34m";
    elif [ "$2" == "succ" ] ; then
        COLOR="$type;32m";
    elif [ "$2" == "warn" ] ; then
        COLOR="$type;33m";
    elif [ "$2" == "err" ] ; then
        COLOR="$type;31m";
    else #default color
        COLOR="0m";
    fi

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";
    
    # Print the text with the specified formatting
    if [ "$type" == 0 ] && [[ -n "$3" ]]; then
        printf "$STARTCOLOR$1$ENDCOLOR $3";
    else
        printf "$STARTCOLOR$1$ENDCOLOR";
    fi
}

printn(){
    # Call the print function and add a newline character
    print "$@"
    echo
}

print_loading(){
    pid=$1
    msg="$2"
    if [[ -n "$3" ]]; then stderr="$3"; fi
    frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    len=${#frames[@]}
    i=1
    
    # Loop until the process is completed
    while kill -0 $pid 2> /dev/null;
    do
        printf "\r ${frames[$i]} $msg" 
        sleep 0.2
        i=$(( 1 + i % $len ))
    done
    
    wait $!; exitCode=$?
    if [ $exitCode -eq 0 ]; then
        print "\r ✔" "succ" "$msg"
    else
        print "\r ✘" "err" "$msg"
        echo "\nError: $(cat "$stderr")"
        exit 1
    fi
    echo
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

print_title(){
    padding=$1
    title="$2"
    if [[ -n $3 ]]; then
        rpadding=$3
    else
        rpadding=$padding
    fi
    # Print the underline characters with green formatting
    printf '\e[4;32m%*s%s%*s\e[0m\n' "$padding" '' "$title"  "$rpadding" ''
}
