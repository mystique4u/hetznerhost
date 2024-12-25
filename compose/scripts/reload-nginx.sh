#!/bin/bash

# Check if Nginx is running
if pgrep nginx > /dev/null; then
    echo "Reloading Nginx..."
    nginx -s reload
else
    echo "Nginx is not running. Starting Nginx..."
    nginx
fi
