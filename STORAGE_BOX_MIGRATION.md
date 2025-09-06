# Hetzner Storage Box Migration Guide

## Problem
Hetzner has moved Storage Boxes to the new API system, and the old Robot Web Service is being deprecated (deadline: July 29, 2025). This is causing SSH connection failures.

## What Changed
- **Old System**: Robot Web Service with direct SSH access
- **New System**: Hetzner Cloud API for management + SSH for file operations
- **Impact**: SSH credentials and connection details may have changed

## Migration Steps

### 1. Get New Storage Box Credentials

1. **Log into the new Hetzner Console**:
   - Go to [console.hetzner.com](https://console.hetzner.com)
   - Navigate to your project
   - Go to "Storage Boxes" section

2. **Get Updated Connection Details**:
   - Note the new **Storage Box name** (may have changed)
   - Get the new **SSH hostname** (format: `username.your-storagebox.de`)
   - Generate new **SSH key pair** if needed
   - Note the **Storage Box ID** for API access

### 2. Update GitHub Secrets

Update these secrets in your GitHub repository:

```
STORAGE_BOX_USER=<new_username>
STORAGE_BOX_HOST=<new_hostname>
STORAGE_BOX_SSH_KEY=<new_private_ssh_key>
```

### 3. Test New Connection

Test the new connection manually:

```bash
# Test SSH connection
ssh -i /path/to/new/private/key -p 23 username@username.your-storagebox.de

# Test rsync
rsync -avz -e "ssh -i /path/to/new/private/key -p 23" \
  /local/path/ username@username.your-storagebox.de:/remote/path/
```

### 4. Alternative: Use Hetzner Cloud API

If SSH continues to fail, consider using the Hetzner Cloud API for backup operations:

```bash
# List storage boxes
curl -H "Authorization: Bearer $HCLOUD_TOKEN" \
  https://api.hetzner.com/v1/storage_boxes

# Upload file via API (if supported)
curl -X POST \
  -H "Authorization: Bearer $HCLOUD_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source":"local_file","destination":"remote_path"}' \
  https://api.hetzner.com/v1/storage_boxes/{id}/actions/upload
```

## Immediate Fix

For now, you can disable the backup role temporarily:

1. **Comment out backup role** in `ansible/playbook.yml`:
   ```yaml
   roles:
     - common
     # - backup  # Temporarily disabled
     - docker
     # ... other roles
   ```

2. **Update your GitHub Secrets** with new Storage Box credentials

3. **Re-enable backup role** once credentials are updated

## Resources

- [Hetzner Storage Box API Documentation](https://docs.hetzner.cloud/reference/hetzner#storage-boxes)
- [Hetzner Console](https://console.hetzner.com)
- [Migration Deadline: July 29, 2025](https://docs.hetzner.com/robot/storage-box/robot-web-service-deprecation)

## Next Steps

1. **Get new credentials** from the new Hetzner Console
2. **Update GitHub Secrets** with new values
3. **Test connection** manually first
4. **Re-run Ansible playbook** with updated credentials
5. **Consider API-based backup** for long-term solution
