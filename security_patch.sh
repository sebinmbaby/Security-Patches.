#!/bin/bash

# Variables
MONTH=$(date +%B)
DATE=$(date +%Y-%m-%d)
OUTPUT_DIR="/security_patch"
OUTPUT_FILE="$OUTPUT_DIR/security_patches_$DATE.csv"
TO="your mail ID"
SUBJECT="Sebin's Server Security Patch Report - $MONTH"
BODY="Please find the attached security patch list for $MONTH."

# Create directory if not exists
mkdir -p "$OUTPUT_DIR"

# Remove old reports older than 180 days
find "$OUTPUT_DIR" -type f -name "security_patches_*.csv" -mtime +180 -delete

# Update package list quietly
apt-get update -qq

# Write CSV header
echo "Sebin's Server Security patches check for $MONTH" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Package Name,Current Version,Available Version,Repository" >> "$OUTPUT_FILE"

# Get security updates
SECURITY_UPDATES=$(apt-get -s upgrade | grep "^Inst" | grep -i security)

if [ -n "$SECURITY_UPDATES" ]; then
    echo "$SECURITY_UPDATES" | while read -r line; do
        PACKAGE=$(echo $line | awk '{print $2}')
        CURRENT=$(echo $line | awk -F '[()]' '{print $2}')
        AVAILABLE=$(echo $line | awk '{print $3}')
        REPO=$(echo $line | awk -F '[][]' '{print $2}')
        echo "$PACKAGE,$CURRENT,$AVAILABLE,$REPO" >> "$OUTPUT_FILE"
    done
else
    echo "No security patches available,NA,NA,NA" >> "$OUTPUT_FILE"
fi

# Send email
echo "$BODY" | mail -s "$SUBJECT" -A "$OUTPUT_FILE" "$TO"