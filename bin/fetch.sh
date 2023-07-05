
docker_project_name=$(echo $workdir | xargs basename) 
echo "NAME=$docker_project_name" > $workdir/.runner


echo "GIT=$GIT" >> $workdir/.runner
echo "BRANCH=$(echo $JSON_RES | jq -r ".ref" | xargs basename)" >> $workdir/.runner
echo "COMMIT=$(echo "$JSON_RES" | jq -r ".object.sha")" >> $workdir/.runner #send from rebuild
echo "TOKEN=$TOKEN" >> $workdir/.runner
echo "DOMAIN=$DOMAIN" >> $workdir/.runner
