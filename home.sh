#!/bin/bash

# === CONFIG ===
DEST_BASE="/opt/omniscient/imports/home_migrated"
LOG_DIR="/opt/omniscient/logs"
LOG_FILE="$LOG_DIR/home_migration.log"
SOURCE_DIR="$HOME"

EXCLUDE_DIRS=("Downloads" "Documents" "Desktop" "Public" "Templates" "Music" "Pictures" "Videos" "snap" "venv" "bin")

# === INIT ===
mkdir -p "$DEST_BASE"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

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
    # Rename duplicate file
    local i=1
    while [ -e "$dest_dir/${base_name%.*}_copy-$i.${base_name##*.}" ]; do
      ((i++))
    done
    local new_name="${base_name%.*}_copy-$i.${base_name##*.}"
    dest_path="$dest_dir/$new_name"
    log "⚠️  Duplicate: $base_name → renamed to $new_name"
  fi

  if mv "$src" "$dest_path"; then
    log "✅ Moved: $base_name → $dest_dir"
  else
    log "❌ ERROR moving: $base_name"
  fi
}

# === FILE PATTERNS PER CATEGORY ===
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
log "🚀 Starting home directory Omniscient file migration..."

shopt -s nullglob

# Filter for files only in home dir (not in excluded folders)
find "$SOURCE_DIR" -maxdepth 1 -type f | while read -r file; do
  filename=$(basename "$file")
  moved=false

  for category in "${!categories[@]}"; do
    for pattern in ${categories[$category]}; do
      for match in $pattern; do
        if [ "$file" == "$match" ]; then
          safe_mv "$file" "$DEST_BASE/$category"
          moved=true
        fi
      done
    done
  done

  if [ "$moved" = false ]; then
    safe_mv "$file" "$DEST_BASE/misc"
  fi
done

shopt -u nullglob

log "🎯 Home directory file migration complete."
log "📂 Files now organized under: $DEST_BASE"
log "📄 Log file: $LOG_FILE"
