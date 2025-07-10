#!/bin/bash

echo "=== 🌐 OMNISCIENT DIAGNOSTIC SUITE ==="

# 1. Check if pyenv is installed and working
echo -e "\n🔍 Checking pyenv status..."
if command -v pyenv >/dev/null 2>&1; then
    echo "✅ pyenv is installed at: $(command -v pyenv)"
    echo "🔁 Active Python version: $(pyenv version || echo 'Error reading version')"
    echo "📄 .python-version file (if exists):"
    cat .python-version 2>/dev/null || echo "None found"
else
    echo "⚠️ pyenv is not installed or not in PATH"
fi

# 2. Check for alias or function override of `mv`
echo -e "\n🔍 Checking if 'mv' is overridden..."
type mv
alias | grep -E '^alias mv=' && echo "⚠️ Alias found for mv!" || echo "✅ No alias for mv"
declare -f mv >/dev/null && echo "⚠️ Function override for mv exists!" || echo "✅ No function override for mv"

# 3. Check LD_PRELOAD/LD_LIBRARY_PATH for poisoning
echo -e "\n🔍 Checking environment for poisoning..."
echo "LD_PRELOAD: ${LD_PRELOAD:-None}"
echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH:-None}"

# 4. Test /opt write access and ownership
echo -e "\n🔍 Checking /opt permissions..."
if [ -w /opt ]; then
    echo "✅ /opt is writable by current user"
else
    echo "⚠️ /opt is NOT writable! Suggest: sudo chown -R $(whoami) /opt"
fi
ls -ld /opt

# 5. Check dmesg logs for segfaults
echo -e "\n🧠 Checking for segfaults in kernel logs..."
dmesg | grep -i segfault | tail -5 || echo "✅ No segfaults found"

# 6. Check for broken symlinks or corrupted /opt files
echo -e "\n🔍 Checking for broken symlinks or corrupted files in /opt..."
find /opt -xtype l -ls
find /opt -type f -size 0 -exec ls -l {} \;

# 7. Filesystem health check (non-invasive)
echo -e "\n🧪 SMART status summary for /dev/sda:"
sudo smartctl -H /dev/sda || echo "⚠️ smartctl not installed
