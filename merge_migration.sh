#!/bin/bash

SOURCE_DIR="$HOME/merge"
DEST_DIR="/opt/omniscient/imports/merge_migrated"
LOG_FILE="/opt/omniscient/logs/merge_migration.log"
MANIFEST="/opt/omniscient/logs/merge_manifest.csv"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] 🚀 Starting Omniscient merge directory migration..." | tee -a "$LOG_FILE"
echo "filename,category,sha256" > "$MANIFEST"

mkdir -p "$DEST_DIR"/{scripts,installers,docs,modules,misc}

safe_mv() {
  local src="$1"
  local category="$2"
  local base_name
  base_name=$(basename "$src")
  local dest_path="$DEST_DIR/$category/$base_name"

  # Deduplicate if exists
  if [ -e "$dest_path" ]; then
    local i=1
    while [ -e "$DEST_DIR/$category/${base_name%.*}_copy-$i.${base_name##*.}" ]; do
      ((i++))
    done
    dest_path="$DEST_DIR/$category/${base_name%.*}_copy-$i.${base_name##*.}"
    echo "⚠️  Duplicate: $base_name → renamed to $(basename "$dest_path")" | tee -a "$LOG_FILE"
  fi

  if mv "$src" "$dest_path"; then
    sha=$(sha256sum "$dest_path" | awk '{print $1}')
    echo "$base_name,$category,$sha" >> "$MANIFEST"
    echo "✅ Moved: $base_name → $category" | tee -a "$LOG_FILE"
  else
    echo "❌ ERROR moving: $base_name" | tee -a "$LOG_FILE"
  fi
}

# Process files
shopt -s nullglob
for file in "$SOURCE_DIR"/*; do
  if [ -f "$file" ]; then
    case "$file" in
      *.py)        safe_mv "$file" "scripts" ;;
      *.sh)        safe_mv "$file" "installers" ;;
      *.md|*.txt|*.docx) safe_mv "$file" "docs" ;;
      *)           safe_mv "$file" "misc" ;;
    esac
  elif [ -d "$file" ]; then
    folder=$(basename "$file")
    safe_mv "$file" "modules"
  fi
done
shopt -u nullglob

echo "🎯 Merge directory migration complete." | tee -a "$LOG_FILE"
echo "📄 Log: $LOG_FILE" | tee -a "$LOG_FILE"
echo "📊 Manifest: $MANIFEST" | tee -a "$LOG_FILE"
