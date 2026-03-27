#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_CMD="$HOME/.claude/commands"
TARGET_SCRIPTS="$HOME/.claude/scripts"

mkdir -p "$TARGET_CMD" "$TARGET_SCRIPTS"

cp -f "$SCRIPT_DIR"/commands/*.md "$TARGET_CMD/"
cp -f "$SCRIPT_DIR"/scripts/* "$TARGET_SCRIPTS/"

echo "Installed dot-claude commands to $TARGET_CMD"
echo "Installed dot-claude scripts to $TARGET_SCRIPTS"
