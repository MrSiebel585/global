#!/bin/bash
# Script to create the Omniscient system structure and log the directory tree

BASE_DIR="/opt/omniscient"
LOG_FILE="$BASE_DIR/structure_log.txt"

echo "Starting creation of Omniscient system structure..."

# Run directory creation script
if [ -f "./create_system_structure.sh" ]; then
  bash ./create_system_structure.sh
else
  echo "Error: create_system_structure.sh not found."
  exit 1
fi

# Run subdirectory files creation script
if [ -f "./create_subdir_files.sh" ]; then
  bash ./create_subdir_files.sh
else
  echo "Error: create_subdir_files.sh not found."
  exit 1
fi

echo "Logging directory structure to $LOG_FILE..."

# Log the directory tree
if command -v tree >/dev/null 2>&1; then
  tree -a "$BASE_DIR" > "$LOG_FILE"
else
  # Fallback if tree is not installed
  find "$BASE_DIR" > "$LOG_FILE"
fi

echo "Directory structure logged to $LOG_FILE"
