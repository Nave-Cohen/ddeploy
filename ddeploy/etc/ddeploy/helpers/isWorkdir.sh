json_file="$base/configs/deploys.json"
workdir="$PWD"

if [ -n "$1" ]; then
  workdir="$1"
fi

folder=$(jq -r --arg search "$workdir" '.[] | select(.folder == $search) | .folder' "$json_file")

if [[ ! -d "$workdir" ]] || [ -z "$folder" ] || [ ! -f "$workdir/.ddeploy.env" ]; then
  echo ""
else
  echo "$folder"
fi