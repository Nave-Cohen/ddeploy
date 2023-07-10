if [ $# -lt 1 ]; then
    echo "doc token [token]"
    exit 5
fi

token="$1"
commit=$(bash "$base/helpers/fetchCommit.sh" "$token")

if [ -n "$commit" ]; then
    echo "$token" > "$base/configs/token"
    echo "Token is added successfully"
else
    echo "Token is not valid"
fi