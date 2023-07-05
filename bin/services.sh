container_info=$(docker ps --format "{{.Names}}|{{.Image}}|{{.Status}}")

printf "%-20s %-20s %-20s\n" "Name" "Image" "Status"
IFS=$'\n'
for info in $container_info; do
  IFS='|' read -r name image status <<< "$info"
  printf "%-20s %-20s %-20s\n" "$name" "$image" "$status"
done