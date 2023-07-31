# Get HTTP status
output="Domain,Status\n"
for domain in $DOMAINS; do
    http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://$DOMAIN")
    if [[ $http_status == "200" || $http_status == "302" ]]; then
        http_status="200/OK"
    else
        http_status="$http_status/ERROR"
    fi
    output+="$domain,$http_status\n"
done
echo -e $output | column -t -s ','
