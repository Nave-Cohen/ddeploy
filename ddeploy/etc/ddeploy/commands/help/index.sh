
if [ $# -lt 1 ]; then
    cat "$base/commands/help/_help"
    exit 0
fi

sub_command="$base/commands/$1/_help"
if [[ -f "$sub_command" ]]; then
    cat $sub_command
else
    cat "$base/commands/help/_help"
fi