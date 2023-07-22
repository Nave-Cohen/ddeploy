if [ $# -lt 1 ]; then
    echo "doc token [token]"
    exit 5
fi

token="$1"
path="$base/configs/token"
echo "$token" > $path

source "/etc/ddeploy/helpers/repo.sh"

commit=$(fetchCommit "$PWD")
if [ -n "$commit" ]; then
    echo "Token is added successfully"
else
    rm $path
    echo "Token is not valid"
fi