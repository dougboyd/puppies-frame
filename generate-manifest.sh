#!/bin/bash
# Generate manifest.js from photos in the photos/ directory

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PHOTOS_DIR="$SCRIPT_DIR/photos"
MANIFEST_FILE="$SCRIPT_DIR/manifest.js"

# Find all image files and build JSON array
echo "// Auto-generated - do not edit manually" > "$MANIFEST_FILE"
echo "// Run ./generate-manifest.sh to regenerate" >> "$MANIFEST_FILE"
echo "var PHOTO_MANIFEST = [" >> "$MANIFEST_FILE"

first=true
count=0

# Use find to get all image files
while IFS= read -r -d '' file; do
    filename=$(basename "$file")
    if [ "$first" = true ]; then
        first=false
    else
        echo "," >> "$MANIFEST_FILE"
    fi
    printf '    "photos/%s"' "$filename" >> "$MANIFEST_FILE"
    count=$((count + 1))
done < <(find "$PHOTOS_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.heic" -o -iname "*.webp" \) -print0 | sort -z)

echo "" >> "$MANIFEST_FILE"
echo "];" >> "$MANIFEST_FILE"

echo "Generated manifest.js with $count photos"
