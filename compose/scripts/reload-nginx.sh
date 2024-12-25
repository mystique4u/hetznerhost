#!/bin/bash
set -e
nginx -s reload
echo "Nginx reloaded."
