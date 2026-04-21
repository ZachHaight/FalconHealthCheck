#!/bin/bash
# Auto-update list_files.json with all Falcon health check JSON files

cd "$(dirname "$0")"

# Find all JSON files matching the pattern
files=$(ls -1 Falcon_Health_Check_Stats_*.json 2>/dev/null | sort)

# Build JSON array
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

echo "✓ Updated list_files.json with $(echo "$files" | wc -l | tr -d ' ') files"
