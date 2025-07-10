#!/bin/bash
# Purpose: Emergency disk rescue - Free space safely and log actions
# Filename: free_space_now.sh

set -e

LOG="$HOME/freedisk_$(date +%Y%m%d_%H%M%S).log"
echo "[*] Log file: $LOG"

# === Function: Log and print ===
log() {
    echo -e "$1" | tee -a "$LOG"
}

# === Function: Show Top Space Usage ===
log "\n🔍 Top space-consuming directories in /:"
du -h / --max-depth=2 2>/dev/null | sort -hr | head -n 15 | tee -a "$LOG"

log "\n📂 Checking for large files (>100MB):"
find / -type f -size +100M -exec du -h {} + 2>/dev/null | sort -hr | head -n 20 | tee -a "$LOG"

# === 1. Clear apt cache ===
log "\n🧼 Cleaning APT cache..."
sudo apt-get clean

# === 2. Clear journal logs if systemd ===
if command -v journalctl &>/dev/null; then
    log "\n🧹 Vacuuming systemd logs..."
    sudo journalctl --vacuum-time=3d
fi

# === 3. Remove orphaned packages ===
if command -v deborphan &>/dev/null; then
    ORPHANS=$(deborphan)
    if [[ -n "$ORPHANS" ]]; then
        log "\n🚫 Removing orphaned packages: $ORPHANS"
        sudo apt-get remove --purge -y $ORPHANS
    fi
fi

# === 4. Clear thumbnail cache ===
log "\n🧼 Clearing user thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

# === 5. Empty Trash ===
log "\n🗑️ Emptying Trash..."
rm -rf ~/.local/share/Trash/files/*

# === 6. List & prompt removal of largest user files ===
log "\n📛 Listing user files > 200MB in /home:"
find /home -type f -size +200M -exec du -sh {} + 2>/dev/null | sort -hr | tee -a "$LOG"

log "\n✅ Basic cleanup done. Log saved to $LOG"
