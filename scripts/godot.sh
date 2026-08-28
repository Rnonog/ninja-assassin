#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
bundled="$root/tools/Godot_v4.7.2-stable_linux.x86_64"

if command -v godot >/dev/null 2>&1; then
  exec godot "$@"
fi

if [[ -x "$bundled" ]]; then
  exec "$bundled" "$@"
fi

echo "Godot not found on PATH and $bundled is missing." >&2
echo "Run: bash scripts/install-godot.sh" >&2
exit 1
