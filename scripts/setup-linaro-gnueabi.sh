#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"
DOWNLOADS="$TOOLS_DIR/downloads"
ARCHIVE_NAME="gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz"
ARCHIVE="$DOWNLOADS/$ARCHIVE_NAME"
VENDORED_ARCHIVE="$ROOT/third_party/toolchains/$ARCHIVE_NAME"
TOOLCHAIN_DIR="$TOOLS_DIR/${ARCHIVE_NAME%.tar.xz}"
MD5="7d409a976ac5bb68fe52b9c1dc503734"

URLS=(
  "https://mirrors.cstcloud.cn/armbian-releases/_toolchain/$ARCHIVE_NAME"
  "https://mirror.twds.com.tw/armbian-dl/_toolchain/$ARCHIVE_NAME"
  "https://imola.armbian.com/_toolchains/$ARCHIVE_NAME"
  "https://mirrors.netix.net/armbian/dl/_toolchains/$ARCHIVE_NAME"
  "https://mirrors.tuna.tsinghua.edu.cn/armbian-releases/_toolchains/$ARCHIVE_NAME"
  "https://mirrors.dotsrc.org/armbian-dl/_toolchains/$ARCHIVE_NAME"
)

mkdir -p "$DOWNLOADS"

if [ ! -f "$ARCHIVE" ]; then
  if [ -f "$VENDORED_ARCHIVE" ]; then
    cp "$VENDORED_ARCHIVE" "$ARCHIVE"
  else
    for url in "${URLS[@]}"; do
      echo "Downloading $ARCHIVE_NAME from $url"
      if curl -L --fail --show-error --progress-bar -o "$ARCHIVE.tmp" "$url"; then
        mv "$ARCHIVE.tmp" "$ARCHIVE"
        break
      fi
      rm -f "$ARCHIVE.tmp"
    done
  fi
fi

if [ ! -f "$ARCHIVE" ]; then
  echo "Failed to download $ARCHIVE_NAME" >&2
  exit 1
fi

echo "$MD5  $ARCHIVE" | md5sum -c -

if [ ! -d "$TOOLCHAIN_DIR" ]; then
  tar -C "$TOOLS_DIR" -xf "$ARCHIVE"
fi

echo "Linaro arm-linux-gnueabi ready: $TOOLCHAIN_DIR"
