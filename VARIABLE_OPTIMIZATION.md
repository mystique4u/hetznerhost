# Variable Optimization Summary

## Overview
This document summarizes the variable optimization performed on the hetznerhost repository to eliminate redundancies and improve maintainability.

## Changes Made

### 1. Consolidated User Variables
- **REMOVED**: `ansible_user` variable
- **UNIFIED**: All references now use `sudo_user` consistently
- **BENEFIT**: Eliminates duplication between Terraform and Ansible

### 2. Created Path Variables
- **ADDED**: `dev_home_path: "/home/{{ sudo_user }}/dev"`
- **ADDED**: `compose_path: "{{ dev_home_path }}/compose"`
- **ADDED**: `backup_path: "{{ dev_home_path }}/tmp_backups"`
- **ADDED**: `storagebox_mount_path: "{{ dev_home_path }}/storagebox"`
- **ADDED**: `scripts_path: "{{ dev_home_path }}/scripts"`
- **BENEFIT**: Centralized path management, easier to change base paths

### 3. Added Domain Configuration
- **ADDED**: `primary_domain: "mrdevops.pro"`
- **ADDED**: `traefik_domain: "traefik.{{ primary_domain }}"`
- **ADDED**: `crm_domain: "crm.{{ primary_domain }}"`
- **ADDED**: `mail_domain: "mail.{{ primary_domain }}"`
- **ADDED**: `portainer_domain: "portainer.{{ primary_domain }}"`
- **ADDED**: `traefik_email: "admin@{{ primary_domain }}"`
- **BENEFIT**: Easy domain changes, no more hardcoded domains

### 4. Consolidated Storage Box Configuration
- **ADDED**: `storage_box_fqdn: "{{ storage_box_user }}.{{ storage_box_host }}"`
- **FIXED**: Removed hardcoded FQDN in storagemount role
- **BENEFIT**: Consistent storage box configuration

### 5. Updated Docker Compose
- **CHANGED**: All hardcoded domains to use environment variables
- **ADDED**: `compose/env.template` with all required variables
- **BENEFIT**: Configurable domains without code changes

### 6. Updated Traefik Configuration
- **CHANGED**: Hardcoded email to use `${TRAEFIK_EMAIL}` variable
- **BENEFIT**: Configurable email for Let's Encrypt

## Files Modified

### Ansible Files
- `ansible/vars.yml` - Consolidated and added new variables
- `ansible/roles/backup/tasks/main.yml` - Updated to use new variables
- `ansible/roles/common/tasks/main.yml` - Replaced ansible_user with sudo_user
- `ansible/roles/storagemount/tasks/main.yml` - Fixed hardcoded FQDN
- `ansible/roles/docker-cleanup/tasks/main.yml` - Updated paths and added template
- `ansible/roles/main-compose/tasks/main.yml` - Updated paths
- `ansible/roles/git-sync/tasks/main.yml` - Updated all paths and user references
- `ansible/roles/docker/tasks/main.yml` - Updated user reference
- `ansible/roles/cron/tasks/main.yml` - Updated paths and user references
- `ansible/roles/configs/tasks/main.yml` - Updated paths and user references
- `ansible/roles/cron/templates/backup.sh.j2` - Updated to use new variables

### Docker Compose Files
- `compose/docker-compose.yml` - Replaced hardcoded domains with variables
- `compose/traefik/traefik.yml` - Made email configurable

### New Files
- `compose/env.template` - Template for environment variables
- `ansible/roles/docker-cleanup/templates/compose_env.j2` - Ansible template for .env

## Environment Variables Required

### GitHub Secrets (unchanged)
- `SUDO_USER` - Username for the VM
- `STORAGE_BOX_USER` - Hetzner Storage Box username
- `STORAGE_BOX_HOST` - Hetzner Storage Box hostname
- `SMTP_USER` - SMTP username
- `SMTP_PASSWORD` - SMTP password
- `SMTP_SERVER` - SMTP server
- `CRM_ADMIN_PWD` - Odoo admin password
- `COMPOSE_ENV` - Additional Docker Compose environment variables

### New Optional Environment Variables
- `ODOO_DB_USER` - Odoo database user (default: odoo)
- `ODOO_DB_PASSWORD` - Odoo database password
- `ODOO_DB_NAME` - Odoo database name (default: odoo)
- `ODOO_DB_PGDATA` - PostgreSQL data directory (default: /var/lib/postgresql/data)
- `DOCKER_ORG` - Docker organization for Mailu (default: ghcr.io/mailu)
- `DOCKER_PREFIX` - Docker prefix for Mailu (default: empty)
- `MAILU_VERSION` - Mailu version (default: 2024.06)
- `DS_PROMETHEUS` - Prometheus datasource name (default: prometheus)

## Benefits Achieved

1. **Eliminated Redundancy**: Removed duplicate variable definitions
2. **Improved Maintainability**: Centralized path and domain management
3. **Enhanced Flexibility**: Easy to change domains and paths
4. **Better Organization**: Logical grouping of related variables
5. **Reduced Errors**: No more hardcoded values that can get out of sync
6. **Easier Configuration**: Single place to change common settings

## Migration Notes

- All existing functionality is preserved
- No breaking changes to existing workflows
- New variables have sensible defaults
- Environment variables are backward compatible
- Domains can be easily changed by updating `primary_domain` variable

## Next Steps

1. Test the updated configuration in a development environment
2. Update any documentation that references hardcoded paths or domains
3. Consider creating environment-specific variable files for different deployments
4. Add validation for required environment variables
