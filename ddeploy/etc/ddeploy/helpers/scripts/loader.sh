set -a
source /etc/ddeploy/configs/variables.env
import() {
    local file="$1"
    if [[ ! "$imported" =~ "$file" ]]; then
        if [ -f "$functions/$file.sh" ]; then
            source "$functions/$file.sh"
            while read -r function_name; do
                export -f "$function_name"
            done < <(declare -F | awk '{print $3}')
            imported+="$file "
            export imported
        fi
    fi
}
set +a
