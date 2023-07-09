json_file="/etc/doc_cli/configs/enviorments.json"
folder=$(jq -r --arg search "$PWD" '.[] | select(.folder == $search) | .folder' "$json_file")

if [[ -n "$folder" ]]; then
  echo "$folder"
else
  echo ""
fi