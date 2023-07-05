REPO=$(echo "$GIT" | sed -e 's#.*github.com/##' -e 's#\.git$##')
GIT_REF=https://api.github.com/repos/$REPO/git/refs/heads/$BRANCH

docker compose build --build-arg GIT=$GIT --build-arg REF="$GIT_REF"
docker compose up -d
