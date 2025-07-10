#!/bin/bash

DEST_DIR="/opt/omniscient/imports/home_migrated"
MANIFEST="/opt/omniscient/logs/omniscient_manifest.csv"

echo "filename,category,sha256" > "$MANIFEST"

find "$DEST_DIR" -type f | while read -r file; do
  name=$(basename "$file")
  category=$(basename "$(dirname "$file")")
  hash=$(sha256sum "$file" | awk '{print $1}')
  echo "$name,$category,$hash" >> "$MANIFEST"
done

echo "🧾 Manifest saved to $MANIFEST"
