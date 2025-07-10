#!/bin/bash
# Script to create the Omniscient system directory structure under /opt/omniscient

BASE_DIR="/opt/omniscient"

DIRS=(
  "ai"
  "bin"
  "control"
  "modules"
  "osint"
  "python"
  "scripts"
  "system"
  "logs"
  "docs"
  "db"
  "gui"
  "conf"
  "venv"
  "data"
)

echo "Creating Omniscient system directory structure under $BASE_DIR..."

for dir in "${DIRS[@]}"; do
  DIR_PATH="$BASE_DIR/$dir"
  if [ ! -d "$DIR_PATH" ]; then
    mkdir -p "$DIR_PATH"
    echo "Created directory: $DIR_PATH"
  else
    echo "Directory already exists: $DIR_PATH"
  fi
done

echo "Directory structure creation complete."
