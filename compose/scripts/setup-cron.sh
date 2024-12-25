#!/bin/bash

# Write a cron job for certificate renewal
echo "0 0 * * * /scripts/issue-certificates.sh" > /etc/crontabs/root

# Start the cron daemon
crond -f
