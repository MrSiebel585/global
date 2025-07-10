#!/bin/bash

SOURCE_DIR="$HOME"
DEST_DIR="/opt/omniscient/imports/home_migrated"
LOG_FILE="/opt/omniscient/logs/home_cleanup.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] 🔥 Starting Omniscient cleanup..." | tee -a "$LOG_FILE"

find "$DEST_DIR" -type f | while read -r migrated_file; do
  base_name=$(basename "$migrated_file")
  original_path="$SOURCE_DIR/$base_name"

  if [ -f "$original_path" ]; then
    rm -f "$original_path" && echo "🗑️ Deleted orphan: $original_path" | tee -a "$LOG_FILE"
  fi
done

echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Cleanup complete." | tee -a "$LOG_FILE"
