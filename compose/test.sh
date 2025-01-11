#!/bin/bash

echo "Raw extraction:"
# Extract domains directly from the docker-compose.yml using the optimized regex
grep -oP 'Host\(`\K[^\`]+(?=`\))' docker-compose.yml

echo "Domains after processing:"
# Extract and trim everything after the first dot
DOMAINS=$(grep -oP 'Host\(`\K[^\`]+(?=`\))' docker-compose.yml | cut -d '.' -f 1)
echo "$DOMAINS"

# Write domains to a file for further processing
echo "$DOMAINS" > ./domains.txt

# Debug to check the contents of domains.txt
echo "Contents of domains.txt:"
cat ./domains.txt