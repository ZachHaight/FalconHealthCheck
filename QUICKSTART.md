# Quick Start Guide (5 Minutes)

Get the Falcon Health Check Visualizer running in under 5 minutes.

## Option 1: Local Development

Perfect for testing or viewing data on your local machine.

```bash
# 1. Clone the repository
git clone https://github.com/ZachHaight/FalconHealthCheck
cd FalconHealthCheck

# 2. Add your health check data files
# Copy JSON files into the project directory
cp ~/Downloads/Falcon_Health_Check_Stats_*.json .

# 3. Start a local web server
python3 -m http.server 8000

# 4. Open in browser
open http://localhost:8000/FalconHealthCheckVisualizer.html
```

**Done!** The visualizer will auto-detect all JSON files in the directory.

---

## Option 2: GitHub Pages (Free Hosting)

Host the visualizer for free on GitHub Pages with data stored in S3.

### Prerequisites
- GitHub account
- AWS account with S3 access

### Setup Steps

**1. Fork and Enable GitHub Pages** (2 minutes)
```bash
# Fork the repo on GitHub, then:
git clone https://github.com/YOUR-USERNAME/FalconHealthCheck
cd FalconHealthCheck

# Push to GitHub (if not already)
git push origin main
```

In GitHub:
1. Go to **Settings** → **Pages**
2. Source: **Deploy from branch**
3. Branch: **main** → **/ (root)**
4. Click **Save**

Your visualizer will be live at: `https://YOUR-USERNAME.github.io/FalconHealthCheck/FalconHealthCheckVisualizer.html`

**2. Create S3 Bucket for Data** (2 minutes)
```bash
# Create bucket (replace with your bucket name)
aws s3 mb s3://falcon-health-data-YOUR-ORG

# Enable CORS
cat > cors.json << 'EOF'
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "HEAD"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
EOF

aws s3api put-bucket-cors --bucket falcon-health-data-YOUR-ORG --cors-configuration file://cors.json

# Make bucket public-readable (or use signed URLs - see DEPLOYMENT.md)
aws s3api put-bucket-policy --bucket falcon-health-data-YOUR-ORG --policy '{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::falcon-health-data-YOUR-ORG/*"
  }]
}'
```

**3. Upload Data** (1 minute)
```bash
# Upload your health check JSON files
aws s3 cp Falcon_Health_Check_Stats_2026-04-24_*.json s3://falcon-health-data-YOUR-ORG/

# Generate manifest
./generate_manifest_from_s3.sh s3://falcon-health-data-YOUR-ORG
```

**4. Configure Visualizer**

Edit `FalconHealthCheckVisualizer.html` line ~1671:
```javascript
const DATA_SOURCE_URL = 'https://falcon-health-data-YOUR-ORG.s3.us-east-1.amazonaws.com/';
```

Commit and push:
```bash
git add FalconHealthCheckVisualizer.html
git commit -m "Configure S3 data source"
git push origin main
```

**Done!** Visit your GitHub Pages URL to see the live visualizer.

---

## Updating Data (Ongoing)

```bash
# Upload new health check file
aws s3 cp Falcon_Health_Check_Stats_NEW.json s3://falcon-health-data-YOUR-ORG/

# Update manifest
./generate_manifest_from_s3.sh s3://falcon-health-data-YOUR-ORG

# Visualizer auto-loads new data on next page refresh
```

---

## Troubleshooting

**"No data files found"**
- Check `list_files.json` exists and contains file paths
- Verify JSON files match naming pattern: `Falcon_Health_Check_Stats_YYYY-MM-DD_*.json`

**CORS errors in browser console**
- Verify S3 CORS configuration: `aws s3api get-bucket-cors --bucket YOUR-BUCKET`
- Check bucket policy allows public read

**GitHub Pages not loading**
- Wait 2-3 minutes after enabling Pages
- Check Actions tab for deployment status
- Verify repository is public (or use private Pages with Pro account)

---

## Next Steps

- **Security:** See [DEPLOYMENT.md](DEPLOYMENT.md) for authentication, CloudFront, and private deployment
- **Automation:** Set up Lambda to auto-update manifest when new files arrive
- **Customization:** See [visualizer branding/README.md](visualizer%20branding/README.md) to customize logos

---

## Security Note

**This quick start creates a PUBLIC visualizer with PUBLIC data.**

If your health check data contains sensitive information:
1. Do NOT use public S3 bucket
2. Follow [DEPLOYMENT.md](DEPLOYMENT.md) for private deployment with authentication
3. Sanitize data before upload (remove customer names, internal IPs, etc.)
