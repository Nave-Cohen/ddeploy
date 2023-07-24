source $base/helpers/json.sh
source $base/helpers/repo.sh

check_required() {
    required_variables=("BUILD" "RUN" "DOMAINS" "MAIL" "PORT" "MYSQL_PASSWORD" "MYSQL_DATABASE" "MYSQL_USER")
    for variable in "${required_variables[@]}"; do
        if [[ -z "${!variable}" ]]; then
            echo "Error: $variable must be defined in .ddeploy.env file"
            exit 1
        fi
    done
}

load_vars() {
    set -a
    WORKDIR="$1"
    source "$WORKDIR/.ddeploy.env"
    set +a
    if ! check_required; then
        exit 1
    fi
    export DOMAIN="$(echo $DOMAINS | cut -d' ' -f1)"
    export CB_DOMAINS="$(echo $DOMAINS | awk '$1=$1' FS=' ' OFS=' -d ')"
    export GIT="$(getItem "$WORKDIR" git)"
    export COMMIT=$(fetchCommit "$WORKDIR")
    export BRANCH="$(getItem "$WORKDIR" branch)"
    export NAME="$(basename "$WORKDIR")"
}
