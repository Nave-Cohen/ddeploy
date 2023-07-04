#!/bin/sh

# Run Certbot with custom directory paths
certbot certonly --standalone --preferred-challenges http --email nave1616@hotmail.com --agree-tos -d nave.autos --non-interactive --keep-until-expiring
cp -R /etc/letsencrypt/. /certs