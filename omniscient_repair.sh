#!/bin/bash
LOG="$HOME/repair_omniscient.log"
touch "$LOG"
echo "==== 🛠️ OMNISCIENT AUTO-REPAIR START ====" | tee -a "$LOG"

## Step 1: Remove mv aliases/functions
echo -e "\n🚨 Cleaning up mv overrides..." | tee -a "$LOG"
unalias mv 2>/dev/null && echo "✅ Removed mv alias" | tee -a "$LOG"
unset -f mv 2>/dev/null && echo "✅ Removed mv function" | tee -a "$LOG"
type mv | tee -a "$LOG"

## Step 2: Restore /opt permissions (if not writable)
echo -e "\n🔐 Checking /opt permissions..." | tee -a "$LOG"
if [ ! -w /opt ]; then
  echo "⚠️ Attempting to chown /opt to $USER" | tee -a "$LOG"
  sudo chown -R "$USER" /opt && echo "✅ Ownership fixed" | tee -a "$LOG"
else
  echo "✅ /opt is writable by $USER" | tee -a "$LOG"
fi

## Step 3: Repair .python-version if invalid
if [ -f .python-version ]; then
  PYVER=$(cat .python-version)
  pyenv versions --bare | grep -Fx "$PYVER" >/dev/null
  if [ $? -ne 0 ]; then
    echo -e "\n🐍 Python version '$PYVER' from .python-version is invalid" | tee -a "$LOG"
    echo "Attempting reinstall..." | tee -a "$LOG"
    pyenv install "$PYVER" && echo "✅ Installed missing Python $PYVER" | tee -a "$LOG"
  else
    echo "✅ .python-version points to installed version $PYVER" | tee -a "$LOG"
  fi
else
  echo -e "\n📄 No .python-version found – setting fallback" | tee -a "$LOG"
  pyenv global 3.10.13 && echo "✅ pyenv set to 3.10.13" | tee -a "$LOG"
fi

## Step 4: Clean LD_PRELOAD/LD_LIBRARY_PATH if dangerous
echo -e "\n🧹 Cleaning dangerous environment vars..." | tee -a "$LOG"
[[ "$LD_PRELOAD" != "" ]] && unset LD_PRELOAD && echo "✅ Unset LD_PRELOAD" | tee -a "$LOG"
[[ "$LD_LIBRARY_PATH" != "" ]] && unset LD_LIBRARY_PATH && echo "✅ Unset LD_LIBRARY_PATH" | tee -a "$LOG"

## Step 5: Fix venv interpreter if broken
echo -e "\n🧪 Checking venv Python..." | tee -a "$LOG"
VENV_PY="$(which python3)"
[[ ! -x "$VENV_PY" ]] && echo "⚠️ Python in venv not executable: $VENV_PY" | tee -a "$LOG"

## Step
