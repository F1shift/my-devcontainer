#!/bin/bash
set -e

# Path to devcontainer.json
# In a devcontainer, /build-aws-infra-with-AI-demo is usually the root of the repo
DEVCONTAINER_DIR="$(dirname "$(readlink -f "$0")")"
DEVCONTAINER_JSON="$DEVCONTAINER_DIR/devcontainer.json"

if [ ! -f "$DEVCONTAINER_JSON" ]; then
    echo "devcontainer.json not found at $DEVCONTAINER_JSON"
    exit 1
fi

# Extract extensions using Python (using the one installed by uv if available, or system)
# We handle JSONC by removing comments
EXTENSIONS=$(python3 -c "
import json
import re
import sys

try:
    with open('$DEVCONTAINER_JSON', 'r') as f:
        content = f.read()
        # Remove single line comments (but not URL-like strings)
        # This is a simple regex for comments
        content = re.sub(r'//.*?\n', '\n', content)
        # Remove multi-line comments
        content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
        data = json.loads(content)
        extensions = data.get('customizations', {}).get('vscode', {}).get('extensions', [])
        for ext in extensions:
            print(ext)
except Exception as e:
    print(f'Error parsing devcontainer.json: {e}', file=sys.stderr)
    sys.exit(1)
")

for ext in $EXTENSIONS; do
    echo "Installing extension: $ext"
    # agy --install-extension might not be in path, but usually available in devcontainer
    if command -v agy > /dev/null; then
        agy --install-extension "$ext"
    else
        echo "Warning: 'agy' command not found. Skipping $ext"
    fi
done
