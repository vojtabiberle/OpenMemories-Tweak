#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"

for cmd in arm-linux-gnueabi-gcc arm-linux-gnueabi-g++; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing $cmd on PATH." >&2
    echo "Install/unpack Linaro gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi and prepend its bin directory." >&2
    exit 1
  fi
done

if [ ! -d "$TOOLS_DIR/android-ndk-r14b" ]; then
  "$ROOT/scripts/setup-ndk-r14b.sh"
fi

cat > "$ROOT/local.properties" <<EOF
sdk.dir=$TOOLS_DIR/android-sdk
ndk.dir=$TOOLS_DIR/android-ndk-r14b
EOF

cd "$ROOT"
GRADLE_USER_HOME="$TOOLS_DIR/gradle-home" \
JAVA_HOME="$TOOLS_DIR/jdk8" \
"$TOOLS_DIR/gradle-4.10.3/bin/gradle" assembleDebug --no-daemon --stacktrace
