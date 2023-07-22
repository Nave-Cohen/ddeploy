source $base/helpers/json.sh

check_required() {
    required_variables=("BUILD" "RUN" "DOMAIN" "MAIL" "APP_PORT" "MYSQL_PASSWORD" "MYSQL_DATABASE" "MYSQL_USER")
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
    export GIT="$(getItem "$WORKDIR" git)"
    export BRANCH="$(getItem "$WORKDIR" branch)"
    export BACKEND_PORT="$(getItem "$WORKDIR" port)"
    export NAME="$(basename "$WORKDIR")"
}
