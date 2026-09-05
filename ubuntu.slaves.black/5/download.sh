#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_REPO="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git"
SOURCE_PATH="ubuntu.slaves.black/5"
DEST_DIR="$SCRIPT_DIR"

command -v git >/dev/null 2>&1 || { echo "ERROR: git is required." >&2; exit 1; }

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth 1 --filter=blob:none --sparse "$SOURCE_REPO" "$TMP_DIR/source" >/dev/null 2>&1
git -C "$TMP_DIR/source" sparse-checkout set "$SOURCE_PATH"

if [ -d "$TMP_DIR/source/$SOURCE_PATH/packages" ]; then
    rm -rf "$DEST_DIR/packages"
    cp -a "$TMP_DIR/source/$SOURCE_PATH/packages" "$DEST_DIR/"
    printf 'Downloaded %s/packages from %s into %s/packages\n' "$SOURCE_PATH" "$SOURCE_REPO" "$DEST_DIR"
else
    printf 'Source %s has no packages directory; nothing to download.\n' "$SOURCE_PATH"
fi
