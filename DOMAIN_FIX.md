# Domain Management Fix

## Problem
The GitHub Actions workflow was creating DNS records with literal variable names like `${TRAEFIK_DOMAIN}`, `${CRM_DOMAIN}`, etc. instead of the actual domain values. This happened because the domain extraction script was reading the raw variable names from the Docker Compose file before environment variable expansion.

## Root Cause
The domain extraction script was using regex to extract domain names from the `docker-compose.yml` file, but it was capturing the literal variable names `${TRAEFIK_DOMAIN}` instead of the actual domain values because:
1. The script ran before environment variable expansion
2. The Docker Compose file contained variable references, not actual domain values
3. The script was trying to extract domains from a file that hadn't been processed yet

## Solution
Updated the GitHub Actions workflow to:

1. **Define domains directly** instead of extracting from Docker Compose
2. **Use configurable primary domain** via GitHub secret `PRIMARY_DOMAIN`
3. **Process subdomains correctly** by combining them with the primary domain
4. **Pass domain configuration to Ansible** via environment variables

## Changes Made

### GitHub Actions Workflow (`.github/workflows/deploy-server.yml`)
- **Replaced** domain extraction from Docker Compose with direct domain definition
- **Added** support for `PRIMARY_DOMAIN` GitHub secret (defaults to `mrdevops.pro`)
- **Fixed** domain processing to create full domain names (e.g., `traefik.mrdevops.pro`)
- **Added** `PRIMARY_DOMAIN` environment variable to Ansible execution

### Ansible Configuration (`ansible/vars.yml`)
- **Updated** `primary_domain` to use environment variable with fallback
- **Maintained** all computed domain variables (traefik_domain, crm_domain, etc.)

## Expected Behavior Now
The workflow will now:
1. Use `mrdevops.pro` as the primary domain (or `PRIMARY_DOMAIN` secret if set)
2. Create DNS records for:
   - `traefik.mrdevops.pro`
   - `crm.mrdevops.pro`
   - `mail.mrdevops.pro`
   - `portainer.mrdevops.pro`
3. Pass the domain configuration to Ansible for Docker Compose generation

## GitHub Secrets Required
- `PRIMARY_DOMAIN` (optional) - Your primary domain (defaults to `mrdevops.pro`)
- All existing secrets remain the same

## Testing
To test the fix:
1. Run the GitHub Actions workflow
2. Check the logs for "Processing domain: traefik.mrdevops.pro" (not `${TRAEFIK_DOMAIN}`)
3. Verify DNS records are created in your Hetzner DNS panel
4. Confirm domains resolve to your server IP

## Benefits
- ✅ **Fixed domain creation** - No more literal variable names in DNS
- ✅ **Configurable domains** - Easy to change primary domain via secret
- ✅ **Consistent naming** - All domains follow the same pattern
- ✅ **Better error handling** - Clear domain names in logs
- ✅ **Maintainable** - No complex regex extraction needed
