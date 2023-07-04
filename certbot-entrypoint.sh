#!/bin/sh

# Run Certbot with custom directory paths
certbot certonly --webroot -w /var/www/letsencrypt --preferred-challenges http-01 --email nave1616@hotmail.com --agree-tos -d nave.autos --non-interactive --keep-until-expiring
cp -R /etc/letsencrypt/. /certs
cp -R /var/www/letsencrypt/. /html