# Quick Start: Deploy to S3 with Auto-Updates

## Prerequisites

- AWS CLI configured (`aws configure`)
- S3 bucket created
- GitHub account (optional, for GitHub Pages hosting)

## 5-Minute Setup

### 1. Create S3 Bucket & Configure CORS

```bash
BUCKET_NAME="your-company-falcon-data"

# Create bucket
aws s3 mb s3://$BUCKET_NAME

# Configure CORS
cat > /tmp/cors.json <<EOF
{
  "CORSRules": [{
    "AllowedOrigins": ["*"],
    "AllowedMethods": ["GET"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 3000
  }]
}
EOF

aws s3api put-bucket-cors --bucket $BUCKET_NAME --cors-configuration file:///tmp/cors.json

# Make files public
cat > /tmp/policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicRead",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
  }]
}
EOF

aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file:///tmp/policy.json
```

### 2. Update Visualizer Configuration

Edit `FalconHealthCheckVisualizer.html` line ~1671:

```javascript
const DATA_SOURCE_URL = 'https://your-company-falcon-data.s3.us-east-1.amazonaws.com/';
```

Replace with your actual bucket URL.

### 3. Upload Data to S3

```bash
# Upload JSON files
aws s3 sync . s3://$BUCKET_NAME/ \
  --exclude "*" \
  --include "Falcon_Health_Check_Stats_*.json"

# Generate and upload manifest
./generate_manifest_from_s3.sh s3://$BUCKET_NAME
```

### 4. Deploy Visualizer (Choose One)

#### Option A: GitHub Pages (Easiest)

```bash
# Push to GitHub
git add FalconHealthCheckVisualizer.html
git commit -m "Deploy visualizer with S3 backend"
gh repo create falcon-visualizer --public --source=. --remote=origin --push

# Enable Pages
gh repo edit --enable-pages --pages-branch main

# Your visualizer will be live at:
# https://your-username.github.io/falcon-visualizer/FalconHealthCheckVisualizer.html
```

#### Option B: S3 Static Hosting

```bash
# Enable website hosting
aws s3 website s3://$BUCKET_NAME/ --index-document FalconHealthCheckVisualizer.html

# Upload visualizer
aws s3 cp FalconHealthCheckVisualizer.html s3://$BUCKET_NAME/

# Your visualizer will be live at:
# http://$BUCKET_NAME.s3-website-us-east-1.amazonaws.com/FalconHealthCheckVisualizer.html
```

## Weekly Update Process

When you get a new health check JSON file:

```bash
# 1. Upload new JSON to S3
aws s3 cp Falcon_Health_Check_Stats_2026-04-27_*.json s3://$BUCKET_NAME/

# 2. Update manifest
./generate_manifest_from_s3.sh s3://$BUCKET_NAME

# 3. Done! Visualizer auto-loads new data
```

## Test It

```bash
# Verify files are accessible
curl https://$BUCKET_NAME.s3.amazonaws.com/list_files.json

# Should return JSON with list of files
```

Open visualizer → Refresh → See 7 snapshots!

## Automate with Lambda (Optional)

See `DEPLOYMENT.md` for Lambda function that auto-updates the manifest when you upload new files to S3.

