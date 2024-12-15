#!/bin/bash

# Define the domains array
DOMAINS=()

# Read each domain from the configuration files in the domains directory
for domain_config in ../nginx/domains/*.conf; do
    domain=$(basename "$domain_config" .conf)
    DOMAINS+=("-d $domain")
done

# Run Certbot to request certificates for all domains
docker-compose run --rm certbot certonly --webroot --webroot-path=/var/www/certbot \
  --agree-tos --email mystique4u@gmail.com --noninteractive --expand \
  "${DOMAINS[@]}"

# Reload Nginx after obtaining certificates
docker-compose exec nginx nginx -s reload
