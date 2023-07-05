cd $workdir

docker compose build --build-arg GIT=$GIT --build-arg REF="$GIT_REF"
docker compose up -d
