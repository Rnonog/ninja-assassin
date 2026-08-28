#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
exec "$root/scripts/godot.sh" --headless --path "$root" -s tests/run_tests.gd
