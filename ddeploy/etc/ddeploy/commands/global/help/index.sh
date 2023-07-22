global_help="$base/commands/global/help/_help"

if [ $# -lt 1 ]; then
    cat "$global_help"
    exit 0
fi

global_command="$base/commands/global/$1/_help"
sub_command="$base/commands/$1/_help"

if [[ -f "$global_command" ]]; then
    cat "$global_command"
elif [[ -f "$sub_command" ]]; then
    cat "$sub_command"
else
    cat "$global_help"
fi