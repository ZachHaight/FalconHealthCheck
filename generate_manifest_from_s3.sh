#!/bin/bash
# Generate list_files.json manifest from S3 bucket
# Usage: ./generate_manifest_from_s3.sh s3://your-bucket/path/

set -e

if [ -z "$1" ]; then
    echo "Error: S3 path required"
    echo "Usage: ./generate_manifest_from_s3.sh s3://your-bucket/path/"
    exit 1
fi

S3_PATH="$1"

# Remove trailing slash if present
S3_PATH="${S3_PATH%/}"

echo "Scanning S3 path: $S3_PATH"

# List all Falcon health check JSON files in S3
files=$(aws s3 ls "$S3_PATH/" | grep "Falcon_Health_Check_Stats_.*\.json" | awk '{print $4}' | sort)

if [ -z "$files" ]; then
    echo "Error: No Falcon health check JSON files found in $S3_PATH"
    exit 1
fi

# Build JSON manifest
echo '{' > list_files.json
echo '  "files": [' >> list_files.json

first=true
for file in $files; do
    if [ "$first" = true ]; then
        echo "    \"$file\"" >> list_files.json
        first=false
    else
        echo "    ,\"$file\"" >> list_files.json
    fi
done

echo '  ]' >> list_files.json
echo '}' >> list_files.json

file_count=$(echo "$files" | wc -l | tr -d ' ')
echo "✓ Generated list_files.json with $file_count files"

# Optionally upload the manifest back to S3
read -p "Upload list_files.json to S3? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    aws s3 cp list_files.json "$S3_PATH/list_files.json"
    echo "✓ Uploaded list_files.json to $S3_PATH"
fi
