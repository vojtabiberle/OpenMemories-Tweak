#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"
DOWNLOADS="$TOOLS_DIR/downloads"
ARCHIVE="$DOWNLOADS/android-ndk-r14b-linux-x86_64.zip"
NDK_DIR="$TOOLS_DIR/android-ndk-r14b"
URL="https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip"
SHA256="0ecc2017802924cf81fffc0f51d342e3e69de6343da892ac9fa1cd79bc106024"

mkdir -p "$DOWNLOADS"

if [ ! -f "$ARCHIVE" ]; then
  curl -L --fail --show-error --progress-bar -o "$ARCHIVE" "$URL"
fi

echo "$SHA256  $ARCHIVE" | sha256sum -c -

if [ ! -d "$NDK_DIR" ]; then
  unzip -q "$ARCHIVE" -d "$TOOLS_DIR"
fi

echo "NDK r14b ready: $NDK_DIR"
