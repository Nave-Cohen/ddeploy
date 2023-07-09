json_file="$base/configs/deploys.json"
workdir="$PWD"

if [ -n "$1" ]; then
  workdir="$1"
fi

folder=$(jq -r --arg search "$workdir" '.[] | select(.folder == $search) | .folder' "$json_file")

if [[ -n "$folder" ]]; then
  echo "$folder"
else
  echo ""
fi