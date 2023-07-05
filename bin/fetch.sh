
cd "$(dirname "$0")"
docker_project_name=$(cd .. && pwd | cut -d '/' -f 3) 
echo "NAME=$docker_project_name" > ../.runner


get_json_item() {
  local json="$1"
  local key="$2"

  local item=$(echo "$json" | jq -r ".$key")
  echo "$item"
}

ref=$(curl -s "$GIT_REF")
json_ref=$(echo $ref | jq -c .)

echo "BRANCH=$(get_json_item "$json_ref" "ref" | cut -d '/' -f 3)" >> ../.runner
echo "COMMIT=$(get_json_item "$json_ref" "object.sha")" >> ../.runner

echo "DOMAIN=$DOMAIN" >> ../.runner
echo "GIT=$GIT" >> ../.runner
echo "REF=$GIT_REF" >> ../.runner