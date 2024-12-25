#!/bin/bash

DOMAINS=()

# Parse domain configuration files
for domain_config in /etc/nginx/config/domains/*.conf; do
    domain=$(basename "$domain_config" .conf)
    DOMAINS+=("-d $domain")
done

# Start Nginx in HTTP-only mode
echo "Starting Nginx in HTTP-only mode for Certbot validation..."
nginx -c /etc/nginx/nginx-http.conf

# Wait for Nginx to start
sleep 5

# Request certificates for all domains
certbot certonly --webroot --webroot-path=/var/www/certbot \
  --agree-tos --email your-email@example.com --noninteractive --expand \
  "${DOMAINS[@]}"

# Replace HTTP-only configuration with HTTPS-enabled configuration
echo "Switching to HTTPS configuration..."
nginx -s stop
nginx -c /etc/nginx/nginx.conf

# Reload Nginx
/scripts/reload-nginx.sh
