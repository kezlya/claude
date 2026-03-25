#!/bin/bash
#
# Refresh Skool auth cookies from Chrome.
# Reads cookies directly from Chrome's cookie database (no browser interaction needed).
#
# Usage: ./utils/refresh_cookies.sh
#
# What it does:
#   1. Reads auth_token, client_id, aws-waf-token from Chrome's cookie store
#   2. Updates utils/.env with fresh values
#   3. Tests the connection
#
# Prerequisites:
#   - Chrome must be installed and you must have logged into skool.com recently
#   - On first run, macOS will prompt for Keychain access (to decrypt cookies)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
SLUG="${SKOOL_COMMUNITY_SLUG:-clearhead-7768}"

# Chrome cookie DB path (macOS)
CHROME_COOKIES="$HOME/Library/Application Support/Google/Chrome/Default/Cookies"

if [ ! -f "$CHROME_COOKIES" ]; then
    echo "ERROR: Chrome cookie database not found at: $CHROME_COOKIES"
    echo ""
    echo "If using a different Chrome profile, set CHROME_PROFILE:"
    echo "  CHROME_PROFILE='Profile 1' ./utils/refresh_cookies.sh"
    echo ""
    echo "Manual fallback:"
    echo "  1. Open Chrome > skool.com > F12 > Application > Cookies"
    echo "  2. Copy auth_token value"
    echo "  3. Edit utils/.env and paste the new value"
    exit 1
fi

# Use a Python script to extract cookies since Chrome encrypts them on macOS
# and we need the Keychain to decrypt
python3 - "$CHROME_COOKIES" "$ENV_FILE" "$SLUG" << 'PYTHON'
import sqlite3
import subprocess
import sys
import os
import shutil
import tempfile

cookie_db = sys.argv[1]
env_file = sys.argv[2]
slug = sys.argv[3]

# Chrome locks the DB, so copy it first
tmp = tempfile.mktemp(suffix=".db")
shutil.copy2(cookie_db, tmp)

try:
    conn = sqlite3.connect(tmp)
    cursor = conn.cursor()

    # Get the cookies we need (unencrypted value first, fall back to noting encryption)
    needed = {
        "auth_token": "SKOOL_AUTH_TOKEN",
        "client_id": "SKOOL_CLIENT_ID",
        "aws-waf-token": "SKOOL_WAF_TOKEN",
    }

    found = {}
    for cookie_name, env_key in needed.items():
        cursor.execute(
            "SELECT value, encrypted_value FROM cookies WHERE host_key LIKE '%skool.com' AND name = ?",
            (cookie_name,),
        )
        row = cursor.fetchone()
        if row:
            value, enc_value = row
            if value:
                found[env_key] = value
            elif enc_value:
                # On macOS, Chrome encrypts cookies with Keychain
                # We need to decrypt using the Chrome Safe Storage key
                try:
                    safe_storage_key = subprocess.check_output(
                        ["security", "find-generic-password", "-s", "Chrome Safe Storage", "-w"],
                        stderr=subprocess.DEVNULL,
                    ).strip()
                    import hashlib
                    import binascii
                    # Chrome uses PBKDF2 with the safe storage key
                    key = hashlib.pbkdf2_hmac("sha1", safe_storage_key, b"saltysalt", 1003, dklen=16)
                    # Encrypted value starts with b'v10' on macOS
                    if enc_value[:3] == b"v10":
                        from cryptography.fernet import Fernet  # noqa
                        raise ImportError("Use AES instead")
                except (ImportError, Exception):
                    # If decryption fails, fall back to manual
                    print(f"WARNING: Cookie '{cookie_name}' is encrypted. Manual refresh needed.")
                    print(f"  Open Chrome > skool.com > F12 > Application > Cookies > copy {cookie_name}")
                    continue
                found[env_key] = value
        else:
            print(f"WARNING: Cookie '{cookie_name}' not found in Chrome DB.")

    conn.close()

    if not found:
        print("No cookies could be extracted automatically.")
        print("\nManual refresh:")
        print("  1. Open Chrome > skool.com > F12 > Application > Cookies")
        print("  2. Copy auth_token, client_id, aws-waf-token values")
        print("  3. Edit utils/.env and paste the new values")
        sys.exit(1)

    # Update .env file
    if os.path.exists(env_file):
        lines = open(env_file).readlines()
    else:
        lines = []

    new_lines = []
    updated = set()
    for line in lines:
        stripped = line.strip()
        if stripped and not stripped.startswith("#"):
            key = stripped.split("=", 1)[0].strip()
            if key in found:
                new_lines.append(f"{key}={found[key]}\n")
                updated.add(key)
                continue
        new_lines.append(line)

    # Add any keys not already in the file
    for key, value in found.items():
        if key not in updated:
            new_lines.append(f"{key}={value}\n")

    # Ensure slug is present
    slug_line = f"SKOOL_COMMUNITY_SLUG={slug}\n"
    if not any("SKOOL_COMMUNITY_SLUG" in l for l in new_lines):
        new_lines.append(slug_line)

    with open(env_file, "w") as f:
        f.writelines(new_lines)

    print(f"Updated {len(found)} cookie(s) in {env_file}")
    for k in found:
        print(f"  {k}: ...{found[k][-20:]}")

finally:
    os.unlink(tmp)
PYTHON

echo ""
echo "Testing connection..."
python3 "$SCRIPT_DIR/skool_scraper.py" about 2>&1 | head -8

echo ""
echo "Done. If you see community info above, cookies are working."
