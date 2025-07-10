#!/bin/bash

# === CONFIG ===
DEST_BASE="/opt/omniscient/imports/organized"
LOG_DIR="/opt/omniscient/logs"
LOG_FILE="$LOG_DIR/import_organizer.log"
SOURCE_DIR="$HOME/Downloads"

# === INIT ===
mkdir -p "$DEST_BASE"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

safe_mv() {
  local src="$1"
  local dest_dir="$2"
  local base_name
  base_name=$(basename "$src")
  local dest_path="$dest_dir/$base_name"

  mkdir -p "$dest_dir"

  if [ -e "$dest_path" ]; then
    # Resolve conflict with _copy-N
    local i=1
    while [ -e "$dest_dir/${base_name%.*}_copy-$i.${base_name##*.}" ]; do
      ((i++))
    done
    local new_name="${base_name%.*}_copy-$i.${base_name##*.}"
    dest_path="$dest_dir/$new_name"
    log "⚠️  Duplicate detected: $base_name → renamed to $new_name"
  fi

  if mv "$src" "$dest_path"; then
    log "✅ Moved: $(basename "$src") → $dest_dir"
  else
    log "❌ ERROR moving: $(basename "$src")"
  fi
}

# === CATEGORY GROUPS ===
declare -A categories=(
  [installers]="$SOURCE_DIR/install_*.sh $SOURCE_DIR/init*.sh"
  [logs]="$SOURCE_DIR/*.log $SOURCE_DIR/*flatfiles*"
  [archives]="$SOURCE_DIR/*.zip $SOURCE_DIR/*.tar.xz"
  [agents]="$SOURCE_DIR/hf* $SOURCE_DIR/chatgpt* $SOURCE_DIR/omniscientctl*"
  [packages]="$SOURCE_DIR/omnidocgen_*.deb"
  [docs]="$SOURCE_DIR/Omniscient_Project_File_Legend.csv $SOURCE_DIR/Omniscient_Codebase_AI_Explanations.csv"
  [tools]="$SOURCE_DIR/generate_omniscient_envs.sh $SOURCE_DIR/merge_omniscient $SOURCE_DIR/pipctl*.sh $SOURCE_DIR/universal_c2_launcher.sh"
)

# === START ===
log "🧭 [$TIMESTAMP] Beginning Omniscient file migration..."

shopt -s nullglob

# Process categorized files
for category in "${!categories[@]}"; do
  for pattern in ${categories[$category]}; do
    for file in $pattern; do
      [ -e "$file" ] && safe_mv "$file" "$DEST_BASE/$category"
    done
  done
done

# Process files from legacy ~/Downloads/omniscient_organized/
if [ -d "$SOURCE_DIR/omniscient_organized" ]; then
  log "📦 Found legacy folder: omniscient_organized — importing contents recursively..."
  find "$SOURCE_DIR/omniscient_organized" -type f | while read -r file; do
    subdir=$(basename "$(dirname "$file")")
    safe_mv "$file" "$DEST_BASE/$subdir"
  done
  rm -r "$SOURCE_DIR/omniscient_organized"
  log "🧹 Removed old: ~/Downloads/omniscient_organized/"
fi

# Catch-all for orphaned Omniscient-tagged files
for file in "$SOURCE_DIR"/*omniscient*; do
  [ -e "$file" ] && safe_mv "$file" "$DEST_BASE/misc"
done

shopt -u nullglob

log "🎯 Omniscient file migration and organization complete."
log "📍 Files now located under: $DEST_BASE"
log "🗂️  Full migration log: $LOG_FILE"
