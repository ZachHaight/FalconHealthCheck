# Cloud Deployment Guide

This guide explains how to deploy the CrowdStrike Health Check Visualizer with cloud storage (S3) for automatic data updates.

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│  Web Server (GitHub Pages / S3 Static Hosting) │
│  - visualizer.html                              │
│  - list_files.json (manifest)                   │
└─────────────────────────────────────────────────┘
                    ↓ fetches data from
┌─────────────────────────────────────────────────┐
│  S3 Bucket (Data Storage)                       │
│  - Falcon_Health_Check_Stats_*.json             │
│  - list_files.json (auto-generated)             │
└─────────────────────────────────────────────────┘
```

## Deployment Steps

### 1. Set Up S3 Bucket

Create an S3 bucket to store your health check JSON files:

```bash
# Create bucket
aws s3 mb s3://your-company-falcon-data

# Enable CORS for web access
aws s3api put-bucket-cors --bucket your-company-falcon-data --cors-configuration file://s3-cors.json
```

**s3-cors.json:**
```json
{
  "CORSRules": [
    {
      "AllowedOrigins": ["*"],
      "AllowedMethods": ["GET"],
      "AllowedHeaders": ["*"],
      "MaxAgeSeconds": 3000
    }
  ]
}
```

### 2. Configure Public Read Access

Make the data files publicly readable:

```bash
# Create bucket policy
cat > bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::your-company-falcon-data/*"
    }
  ]
}
EOF

aws s3api put-bucket-policy --bucket your-company-falcon-data --policy file://bucket-policy.json
```

**⚠️ Security Note:** Only make this bucket public if the health check data is not sensitive. For sensitive data, use CloudFront with signed URLs or authenticated access.

### 3. Update Visualizer Configuration

Edit `visualizer.html` and set the `DATA_SOURCE_URL`:

```javascript
// ========== CONFIGURATION ==========
// Set DATA_SOURCE_URL to your S3 bucket URL or leave empty for local files
// Example: 'https://your-bucket.s3.us-east-1.amazonaws.com/data/'
const DATA_SOURCE_URL = 'https://your-company-falcon-data.s3.us-east-1.amazonaws.com/';
// ===================================
```

### 4. Deploy Visualizer to Web Server

#### Option A: GitHub Pages (Recommended for Simplicity)

```bash
# Create GitHub repo
gh repo create falcon-visualizer --public --source=. --remote=origin

# Commit and push
git add visualizer.html list_files.json
git commit -m "Deploy visualizer"
git push -u origin main

# Enable GitHub Pages
gh repo edit --enable-pages --pages-branch main
```

Your visualizer will be live at: `https://your-username.github.io/falcon-visualizer/visualizer.html`

#### Option B: S3 Static Website Hosting

```bash
# Enable static website hosting
aws s3 website s3://your-company-falcon-data/ --index-document visualizer.html

# Upload visualizer
aws s3 cp visualizer.html s3://your-company-falcon-data/
aws s3 cp list_files.json s3://your-company-falcon-data/
```

Your visualizer will be live at: `http://your-company-falcon-data.s3-website-us-east-1.amazonaws.com`

### 5. Upload Initial Data

```bash
# Upload all JSON health check files
aws s3 sync . s3://your-company-falcon-data/ \
  --exclude "*" \
  --include "Falcon_Health_Check_Stats_*.json"

# Generate and upload manifest
./generate_manifest_from_s3.sh s3://your-company-falcon-data
```

## Automated Weekly Updates

### Option 1: GitHub Actions (Manifest Update)

Create `.github/workflows/update-manifest.yml`:

```yaml
name: Update Data Manifest

on:
  schedule:
    - cron: '0 2 * * 1'  # Every Monday at 2 AM
  workflow_dispatch:      # Manual trigger

jobs:
  update-manifest:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Configure AWS
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Generate manifest from S3
        run: |
          ./generate_manifest_from_s3.sh s3://your-company-falcon-data
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add list_files.json
          git commit -m "Update manifest [skip ci]" || echo "No changes"
          git push
```

### Option 2: AWS Lambda (Automatic on Upload)

Create a Lambda function triggered by S3 uploads:

```python
# lambda_update_manifest.py
import json
import boto3

s3 = boto3.client('s3')
BUCKET = 'your-company-falcon-data'

def lambda_handler(event, context):
    # List all health check files
    response = s3.list_objects_v2(
        Bucket=BUCKET,
        Prefix='Falcon_Health_Check_Stats_'
    )

    files = [
        obj['Key'] for obj in response.get('Contents', [])
        if obj['Key'].endswith('.json')
    ]
    files.sort()

    # Generate manifest
    manifest = {'files': files}

    # Upload manifest
    s3.put_object(
        Bucket=BUCKET,
        Key='list_files.json',
        Body=json.dumps(manifest, indent=2),
        ContentType='application/json'
    )

    return {'statusCode': 200, 'body': f'Updated manifest with {len(files)} files'}
```

**Lambda Trigger:** Configure S3 event notification for `PUT` operations on `Falcon_Health_Check_Stats_*.json` files.

### Option 3: Cron Job (Manual Upload)

Add this to your crontab:

```bash
# Every Monday at 3 AM
0 3 * * 1 cd /path/to/data && aws s3 cp Falcon_Health_Check_Stats_*.json s3://your-company-falcon-data/ && /path/to/generate_manifest_from_s3.sh s3://your-company-falcon-data
```

## Testing

1. **Local Testing:**
   ```bash
   # Set DATA_SOURCE_URL to empty string
   python3 -m http.server 9000
   # Visit http://localhost:9000/visualizer.html
   ```

2. **Cloud Testing:**
   ```bash
   # Verify S3 files are accessible
   curl https://your-company-falcon-data.s3.amazonaws.com/list_files.json

   # Test visualizer
   curl https://your-username.github.io/falcon-visualizer/visualizer.html
   ```

## Workflow Summary

**Weekly Data Update Process:**

1. New health check JSON file generated → `Falcon_Health_Check_Stats_2026-04-20_*.json`
2. Upload to S3: `aws s3 cp Falcon_Health_Check_Stats_2026-04-20_*.json s3://your-company-falcon-data/`
3. Trigger manifest update (automatically via Lambda or manually via script)
4. Visualizer automatically loads new data on next page load

**No code changes required!** Just drop new JSON files into S3.

## Security Best Practices

1. **For Internal Use:**
   - Use CloudFront with signed URLs
   - Restrict S3 bucket policy to your organization's IP ranges
   - Use AWS Cognito for authentication

2. **For External Sharing:**
   - Sanitize data before upload (remove sensitive CID info if needed)
   - Use bucket policies to restrict access
   - Enable S3 access logging

3. **Credentials:**
   - Never commit AWS credentials to GitHub
   - Use GitHub Secrets for Actions
   - Use IAM roles with least privilege

## Troubleshooting

**CORS Errors:**
- Verify CORS configuration: `aws s3api get-bucket-cors --bucket your-company-falcon-data`
- Check browser console for specific errors

**404 Errors:**
- Verify files are publicly readable: `curl https://your-bucket.s3.amazonaws.com/list_files.json`
- Check `DATA_SOURCE_URL` ends with `/`

**Data Not Updating:**
- Clear browser cache (`Cmd + Shift + R`)
- Verify `list_files.json` was updated in S3
- Check S3 file timestamps

## Cost Estimates (AWS)

- **S3 Storage:** ~$0.023/GB/month (estimate: ~$2-5/month for 100GB of JSON files)
- **S3 Requests:** $0.0004/1000 GET requests (negligible for typical usage)
- **Data Transfer:** $0.09/GB out (first 10TB) - free if using CloudFront

**Estimated monthly cost:** <$10 for typical usage
