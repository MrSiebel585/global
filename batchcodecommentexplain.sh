#!/bin/bash
# comment_all_code.bash

find /opt/omniscient -type f \( -name "*.sh" -o -name "*.py" \) | while read -r FILE; do
  echo "Commenting $FILE..."
  python3 code_commenter.py "$FILE" > "${FILE}.commented"
done
