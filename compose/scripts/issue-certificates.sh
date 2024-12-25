#!/bin/sh
set -e

# Directories and file paths
DOMAINS_DIR="/etc/nginx/conf.d/domains"
CERTBOT_WEBROOT="/var/www/certbot"
RELOAD_SCRIPT="/scripts/reload-nginx.sh"
CRON_FILE="/etc/crontabs/root"

# Function to reload Nginx
reload_nginx() {
    if [ -x "$RELOAD_SCRIPT" ]; then
        echo "Reloading Nginx..."
        sh "$RELOAD_SCRIPT"
    else
        echo "Reload script $RELOAD_SCRIPT not found or not executable."
    fi
}

# Loop through all domain configuration files
for domain_config in ${DOMAINS_DIR}/*.conf; do
    # Skip if no files found
    [ -f "$domain_config" ] || { echo "No domain configurations found. Skipping."; continue; }
    
    # Extract the server_name(s) from the configuration using grep -E instead of grep -P
    DOMAINS=$(grep -E 'server_name[[:space:]]+[^;]+' "$domain_config" | sed 's/server_name[[:space:]]*//g' | sed 's/;.*//g' | tr '\n' ' ')
    
    if [ -z "$DOMAINS" ]; then
        echo "No domains found in $domain_config. Skipping."
        continue
    fi
    
    echo "Issuing certificates for domains: $DOMAINS"
    
    # Run Certbot to issue certificates
    certbot certonly --webroot -w $CERTBOT_WEBROOT \
        --agree-tos --email mystique4u@gmail.com --noninteractive \
        --expand --keep-until-expiring -d $DOMAINS
done

echo "Certificate issuance complete."

# Reload Nginx after issuing certificates
reload_nginx

# Ensure a cron job exists for renewing certificates
if [ ! -f "$CRON_FILE" ]; then
    echo "Setting up cron job for certificate renewal."
    echo "0 0 * * * /scripts/issue-certificates.sh" > "$CRON_FILE"
    chmod 644 "$CRON_FILE"
else
    echo "Cron job for certificate renewal already exists."
fi