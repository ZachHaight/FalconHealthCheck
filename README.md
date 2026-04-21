# CrowdStrike Falcon Health Check Visualizer

Interactive web-based dashboard for visualizing CrowdStrike Falcon health check data across multiple customer instances and time periods.

## Features

- **Interactive Dashboard:** Real-time visualization of sensor health, detections, and policy scores
- **Multi-Snapshot Analysis:** Compare trends across multiple time periods
- **Cost Calculator:** EPP billing estimation with workstation/server classification
- **Cloud Billing:** AWS/Azure/GCP consumption tracking
- **Amazon Exception Tracker:** Special pricing accommodation monitoring
- **Trend Analysis:** Historical performance tracking with delta indicators
- **RBAC Ready:** Customer instance (CID) isolation
- **Dark Mode:** Toggle between light and dark themes

## Quick Start

### Local Testing

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/falcon-visualizer
cd falcon-visualizer

# Start local server
python3 -m http.server 8000

# Open browser
open http://localhost:8000/FalconHealthCheckVisualizer.html
```

### Cloud Deployment with Auto-Updates

Deploy once, then just drop new JSON files into S3 weekly - no code changes needed:

1. **Quick setup:** Follow [`QUICKSTART.md`](QUICKSTART.md) (5 minutes)
2. **Detailed guide:** See [`DEPLOYMENT.md`](DEPLOYMENT.md) for production setup

**Architecture:**
- Visualizer hosted on GitHub Pages or S3 static hosting
- Data files stored in S3 bucket with CORS enabled
- New JSON files → Auto-update manifest → Visualizer loads new data

## Data Format

Health check JSON files must follow this naming pattern:
```
Falcon_Health_Check_Stats_YYYY-MM-DD_HH-MM-SS_7-day_90-day.json
```

See `sample_data.json` for the expected data structure.

## Updating Data

### Local Development
```bash
# Add new JSON file to project folder
cp Falcon_Health_Check_Stats_*.json .

# Update manifest
./update_manifest.sh

# Refresh browser
```

### Production (S3 Backend)
```bash
# Upload new data to S3
aws s3 cp Falcon_Health_Check_Stats_2026-04-27_*.json s3://your-bucket/

# Update manifest (or use Lambda for auto-update)
./generate_manifest_from_s3.sh s3://your-bucket

# Done! Visualizer automatically loads new data on next visit
```

## Configuration

Edit `FalconHealthCheckVisualizer.html` line ~1671 to set your data source:

```javascript
// Local files (default)
const DATA_SOURCE_URL = '';

// S3 bucket
const DATA_SOURCE_URL = 'https://your-bucket.s3.us-east-1.amazonaws.com/';
```

## Dashboard Sections

- **Billing Classification:** OS-based workstation/server categorization
- **EPP Cost Calculator:** Annual/monthly cost estimation ($36.35 workstation, $41.00 server)
- **Cloud Billing Estimation:** Multi-cloud consumption tracking
- **Amazon Exception Tracker:** Special pricing monitoring (AWS Corp Prod only)
- **Trend Analysis:** Historical sensor health and detection patterns
- **Side-by-Side Comparison:** Compare two CIDs directly
- **Bulk Export:** Export multiple CIDs/worksheets as ZIP

## Requirements

- Modern web browser (Chrome, Firefox, Safari, Edge)
- JSON health check data from CrowdStrike Falcon
- (Optional) AWS account for S3 storage
- (Optional) GitHub account for Pages hosting

## Security

- **Public Deployment:** Sanitize data before uploading to public S3/GitHub Pages
- **Private Deployment:** Use CloudFront signed URLs or Cognito authentication
- **Authentication:** Demo uses frontend-only auth - implement proper backend auth for production
- **See:** [`DEPLOYMENT.md`](DEPLOYMENT.md) security best practices section

## File Structure

```
.
├── FalconHealthCheckVisualizer.html                    # Main application
├── list_files.json                    # Data manifest (auto-generated)
├── sample_data.json                   # Example data structure
├── update_manifest.sh                 # Local manifest updater
├── generate_manifest_from_s3.sh       # S3 manifest generator
├── DEPLOYMENT.md                      # Full deployment guide
├── QUICKSTART.md                      # 5-minute setup guide
└── README.md                          # This file
```

## Scripts

- **`update_manifest.sh`** - Scans local folder and updates `list_files.json`
- **`generate_manifest_from_s3.sh`** - Scans S3 bucket and generates manifest

## Support

For issues or questions:
1. Check [`DEPLOYMENT.md`](DEPLOYMENT.md) troubleshooting section
2. Open a GitHub issue with details

## License

Proprietary - Internal use only

