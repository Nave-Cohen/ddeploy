commit=$(echo "$JSON_RES" | jq -r ".object.sha")
sed -E "s/(COMMIT=).*/\1$commit/" "$workdir/.runner.env" > "$workdir/.runner.env.tmp"
echo "" >> "$workdir/.runner.env.tmp"  # Add an empty line at the end
mv "$workdir/.runner.env.tmp" "$workdir/.runner.env"
