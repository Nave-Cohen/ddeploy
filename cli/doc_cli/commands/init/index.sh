if [[ -f ".runner.env" ]]; then
    echo allready runner enviorment
    exit 1
fi

cp -r /etc/doc_cli/init/. .
echo + docker-compose.yml
echo + app/Dockerfile
echo + entrypoint

if [[ ! -f ".env" ]]; then
    touch .env
    echo + .env
fi

echo -e 'GIT=#git repository url\nBRANCH=#example: main\nDOMAIN=#example.com\nMAIL=\nBACKEND_IP=\nBACKEND_PORT=3000\n' > .runner.env
echo + .runner.env
echo .runner.env must be edited.