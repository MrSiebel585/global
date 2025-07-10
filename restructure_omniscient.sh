#!/bin/bash
set -e

echo "[*] Restructuring Omniscient framework..."

# Define target directory
TARGET="/opt/omniscient_restructured"
LOGS="$TARGET/logs"
BIN="$TARGET/bin"
AI_CORE="$TARGET/ai/core_runtime"
SCRIPTS="$TARGET/scripts"
CONFIG="$TARGET/omniscient.conf"

# Create new structure
mkdir -p "$LOGS" "$BIN" "$AI_CORE" "$SCRIPTS"

# Move known components if they exist
echo "[*] Relocating known components..."

[[ -f /opt/omniscient/omniscientctl ]] && mv /opt/omniscient/omniscientctl "$BIN/"
[[ -f /opt/omniscient/omniscient.conf ]] && cp /opt/omniscient/omniscient.conf "$CONFIG"

[[ -d /opt/omniscient/ai/core_runtime ]] && cp -r /opt/omniscient/ai/core_runtime/* "$AI_CORE/" 2>/dev/null || true
[[ -d /opt/omniscient/user_scripts ]] && cp -r /opt/omniscient/user_scripts "$SCRIPTS/user" || true
[[ -d /opt/omniscient/system_scripts ]] && cp -r /opt/omniscient/system_scripts "$SCRIPTS/system" || true
[[ -d /opt/omniscient/logs ]] && cp -r /opt/omniscient/logs/* "$LOGS/" || true

# Permissions
chmod -R 755 "$TARGET"

# Completion
echo "[✓] Omniscient restructured under: $TARGET"
tree "$TARGET" || find "$TARGET"
