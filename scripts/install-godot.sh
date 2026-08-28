#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
tools="$root/tools"
bin="$tools/Godot_v4.7.2-stable_linux.x86_64"
zip_name="Godot_v4.7.2-stable_linux.x86_64.zip"
url="https://github.com/godotengine/godot-builds/releases/download/4.7.2-stable/${zip_name}"

mkdir -p "$tools"

if [[ -x "$bin" ]]; then
  echo "Godot 4.7.2 already present: $bin"
  exit 0
fi

zip_path="$tools/$zip_name"
echo "Downloading $url"
curl -fL --retry 3 -o "$zip_path" "$url"
unzip -o "$zip_path" -d "$tools"
rm -f "$zip_path"

if [[ ! -f "$bin" ]]; then
  echo "ERROR: expected $bin after unzip" >&2
  ls -la "$tools" >&2 || true
  exit 1
fi

chmod +x "$bin"
echo "Installed $bin"
