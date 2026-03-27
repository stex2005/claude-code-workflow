#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/commands"

mkdir -p "$TARGET_DIR"

cp -f "$SCRIPT_DIR"/commands/*.md "$TARGET_DIR/"

echo "Installed dot-claude commands to $TARGET_DIR"
