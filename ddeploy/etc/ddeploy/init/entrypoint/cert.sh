#!/bin/sh

while true; do
    certbot certonly --webroot -w /var/www/letsencrypt --preferred-challenges http-01 --email "${MAIL}" --agree-tos -d "${DOMAIN}" --non-interactive --keep-until-expiring
    exit_code=$?
    if [ "${exit_code}" -ne 0 ]; then
        echo "Certbot command failed with exit code: ${exit_code}"
        exit "${exit_code}"
    fi
    sleep 12h
done
