#!/bin/bash
# explaincode.bash

read -p "Enter script path to explain (e.g., /opt/omniscient/scripts/myscript.sh): " SCRIPT

if [[ ! -f "$SCRIPT" ]]; then
  echo "File not found!"
  exit 1
fi

echo "Generating explanation for $SCRIPT..."
python3 - <<EOF
import os
from transformers import pipeline

with open("$SCRIPT") as f:
    code = f.read()

explainer = pipeline("text2text-generation", model="t5-base", tokenizer="t5-base")
prompt = "Explain this bash/python code in detail:\n" + code

explanation = explainer(prompt, max_length=512, do_sample=False)[0]['generated_text']
print("\n--- EXPLANATION ---\n", explanation)
EOF
