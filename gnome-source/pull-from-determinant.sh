#!/usr/bin/env bash
set -euo pipefail
umask 022

# Pull the canonical GNOME source tree from Ubuntu.Determinant.Beta.Restricted.
# This script copies only /gnome-source into the current repository checkout.
# It deliberately does not copy the source repository's .git directory.

SOURCE_REPO="${GNOME_SOURCE_REPO:-https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git}"
SOURCE_REF="${GNOME_SOURCE_REF:-main}"
SOURCE_PATH="gnome-source"
DEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$DEST_ROOT/$SOURCE_PATH"
MAX_BYTES="${GNOME_SOURCE_MAX_BYTES:-209715200}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v git >/dev/null || { echo 'ERROR: git is required.' >&2; exit 1; }
command -v du >/dev/null || { echo 'ERROR: du is required.' >&2; exit 1; }
command -v rsync >/dev/null || { echo 'ERROR: rsync is required.' >&2; exit 1; }

if ! [[ "$MAX_BYTES" =~ ^[0-9]+$ ]]; then
  echo 'ERROR: GNOME_SOURCE_MAX_BYTES must be an integer.' >&2
  exit 2
fi

CHECKOUT="$TMP/source-repo"
echo "=== Pulling GNOME source from Ubuntu.Determinant.Beta.Restricted ==="
echo "  Repository: $SOURCE_REPO"
echo "  Ref:        $SOURCE_REF"
echo "  Path:       /$SOURCE_PATH"

git clone \
  --depth 1 \
  --filter=blob:none \
  --sparse \
  --branch "$SOURCE_REF" \
  "$SOURCE_REPO" \
  "$CHECKOUT"

cd "$CHECKOUT"
git sparse-checkout set "$SOURCE_PATH"

test -d "$CHECKOUT/$SOURCE_PATH" || {
  echo "ERROR: source path /$SOURCE_PATH was not found." >&2
  exit 1
}

SOURCE_BYTES="$(du -sb "$CHECKOUT/$SOURCE_PATH" | awk '{print $1}')"
if [ "$SOURCE_BYTES" -gt "$MAX_BYTES" ]; then
  echo "ERROR: GNOME source tree is ${SOURCE_BYTES} bytes, above the ${MAX_BYTES}-byte safety limit." >&2
  echo '       Set GNOME_SOURCE_MAX_BYTES explicitly if a larger transfer is intended.' >&2
  exit 3
fi

mkdir -p "$DEST"
# Preserve the destination directory itself while replacing its pulled contents.
# Existing local helper files are retained unless they overlap with the source tree.
rsync -a --delete \
  --exclude='pull-from-determinant.sh' \
  "$CHECKOUT/$SOURCE_PATH/" \
  "$DEST/"

printf '\nGNOME source pull completed successfully.\n'
printf 'Source: %s @ %s\n' "$SOURCE_REPO" "$SOURCE_REF"
printf 'Size:   %s bytes\n' "$SOURCE_BYTES"
printf 'Target: %s\n' "$DEST"
