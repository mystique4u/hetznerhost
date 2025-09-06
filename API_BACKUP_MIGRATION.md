# Hetzner Storage Box API Migration

## ✅ Complete Refactor: SSH → API

I've completely refactored the backup system to use the Hetzner Cloud API instead of SSH connections. This is much more reliable and future-proof!

## What Changed

### **Old System (SSH-based)**
- ❌ Direct SSH connections to Storage Box
- ❌ SSH key management and host verification
- ❌ Complex fallback logic for connection issues
- ❌ Prone to connection failures

### **New System (API-based)**
- ✅ Uses Hetzner Cloud API for all operations
- ✅ No SSH keys or connection management needed
- ✅ Simple, reliable backup process
- ✅ Uses existing `HCLOUD_TOKEN` for authentication

## New Configuration

### **Required GitHub Secrets**
You need to add **TWO new secrets**:

```
STORAGE_BOX_NAME=your-storagebox-name
HETZNER_STORAGE_API_KEY=your-storage-api-key
```

**Optional**: Remove these old secrets (no longer needed):
- `STORAGE_BOX_USER` ❌
- `STORAGE_BOX_HOST` ❌  
- `STORAGE_BOX_SSH_KEY` ❌

### **How It Works**

1. **API Authentication**: Uses dedicated `HETZNER_STORAGE_API_KEY`
2. **Storage Box Discovery**: Automatically finds your Storage Box by name
3. **Backup Process**:
   - Creates compressed archive of your dev directory
   - Uploads via API to Storage Box
   - Monitors upload progress
   - Cleans up old backups (keeps last 7)

## Setup Steps

### 1. Get Your Storage Box Name
1. Go to [Hetzner Console](https://console.hetzner.com)
2. Navigate to "Storage Boxes"
3. Note the **name** of your Storage Box (e.g., `your-storagebox`)

### 2. Add GitHub Secrets
Add these to your GitHub repository secrets:
```
STORAGE_BOX_NAME=your-actual-storagebox-name
HETZNER_STORAGE_API_KEY=your-storage-api-key
```

**To get your Storage API key:**
1. Go to [Hetzner Console](https://console.hetzner.com)
2. Navigate to "Security" → "API Tokens"
3. Create a new token with Storage Box permissions
4. Copy the token value

### 3. Deploy
Run your GitHub Actions workflow - it will now use the API!

## Benefits

- ✅ **No SSH issues** - No more host key verification failures
- ✅ **Simpler setup** - Only two new secrets needed
- ✅ **More reliable** - API is more stable than SSH
- ✅ **Future-proof** - Uses the new Hetzner API system
- ✅ **Better monitoring** - Shows upload progress and status
- ✅ **Cleaner code** - Much simpler backup logic

## API Endpoints Used

Based on the [Hetzner API documentation](https://docs.hetzner.cloud/reference/hetzner#storage-boxes):

1. **List Storage Boxes**: `GET /v1/storage_boxes`
2. **Upload File**: `POST /v1/storage_boxes/{id}/actions/upload`
3. **Check Action Status**: `GET /v1/actions/{action_id}`

## Debug Information

The new system provides detailed logging:
- Storage Box discovery results
- Backup archive creation status
- Upload progress and completion
- Action status monitoring

## Migration Complete! 🎉

Your backup system is now:
- ✅ **API-based** instead of SSH
- ✅ **More reliable** and future-proof
- ✅ **Simpler to configure** (one secret vs three)
- ✅ **Better monitored** with progress tracking

Just add the `STORAGE_BOX_NAME` and `HETZNER_STORAGE_API_KEY` secrets and you're ready to go!
