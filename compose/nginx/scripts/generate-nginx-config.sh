#!/bin/bash

# Define the Nginx configuration file location
NGINX_CONF_DIR="../nginx/domains"

# Generate a new Nginx config for all domains
echo "Generating Nginx config for all domains..."
for domain_config in $NGINX_CONF_DIR/*.conf; do
    cp "$domain_config" /etc/nginx/conf.d/
done

# Reload Nginx to apply the new configurations
docker-compose exec nginx nginx -s reload
