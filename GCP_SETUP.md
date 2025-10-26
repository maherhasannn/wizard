# Google Cloud Platform Setup for File Uploads

This document outlines the setup required for GCP Storage integration in the Wizard API.

## Prerequisites

1. Google Cloud Platform account
2. A GCP project created
3. Google Cloud Storage API enabled

## Setup Steps

### 1. Create a Storage Bucket

```bash
# Using gcloud CLI
gsutil mb gs://wizard-media

# Or using the GCP Console
# Go to Cloud Storage > Buckets > Create Bucket
# Name: wizard-media
# Location: Choose appropriate region
# Storage class: Standard
# Access control: Uniform
```

### 2. Create Service Account

1. Go to IAM & Admin > Service Accounts
2. Click "Create Service Account"
3. Name: `wizard-storage-service`
4. Description: `Service account for file uploads`
5. Click "Create and Continue"

### 3. Grant Permissions

Add the following roles to the service account:
- `Storage Object Admin` - for uploading and managing files
- `Storage Object Viewer` - for reading files

### 4. Create and Download Key

1. Click on the service account
2. Go to "Keys" tab
3. Click "Add Key" > "Create new key"
4. Choose "JSON" format
5. Download the key file

### 5. Environment Variables

Add these to your `.env` file:

```env
GOOGLE_CLOUD_PROJECT_ID="your-project-id"
GOOGLE_CLOUD_KEY_FILE="path/to/service-account-key.json"
GOOGLE_CLOUD_STORAGE_BUCKET="wizard-media"
```

### 6. Bucket Configuration

Make sure your bucket allows public access for profile photos:

```bash
# Make the bucket publicly readable
gsutil iam ch allUsers:objectViewer gs://wizard-media
```

## File Structure

Files are organized in the bucket as follows:
- `profile-photos/{userId}/{uuid}.{extension}` - User profile photos
- `livestream-thumbnails/{streamId}/{uuid}.{extension}` - Livestream thumbnails
- `content-images/{contentId}/{uuid}.{extension}` - Content images

## Security Considerations

1. **File Validation**: Only image files are allowed (configured in multer)
2. **File Size Limits**: 5MB maximum file size
3. **Access Control**: Profile photos are public, other content may be private
4. **Virus Scanning**: Consider implementing virus scanning for uploaded files
5. **Rate Limiting**: Implement rate limiting for upload endpoints

## Testing

Test the upload functionality:

```bash
# Test profile photo upload
curl -X POST \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -F "photo=@/path/to/test-image.jpg" \
  http://localhost:3000/api/networking/profile/photo
```

## Monitoring

Monitor your GCP Storage usage:
1. Go to Cloud Storage > wizard-media bucket
2. Check "Usage" tab for storage and request metrics
3. Set up billing alerts for unexpected usage

## Troubleshooting

### Common Issues

1. **Authentication Error**: Verify service account key file path and permissions
2. **Bucket Not Found**: Ensure bucket name matches environment variable
3. **Permission Denied**: Check IAM roles for service account
4. **File Not Public**: Verify bucket public access settings

### Debug Logs

The API logs upload attempts with these prefixes:
- `🌐 [API] UPLOAD` - Upload request initiated
- `✅ [GCS] Photo uploaded successfully` - Successful upload
- `❌ [GCS] Upload error` - Upload failed
