#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"
LINARO_DIR="$TOOLS_DIR/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi"

if [ ! -d "$LINARO_DIR" ]; then
  "$ROOT/scripts/setup-linaro-gnueabi.sh"
fi

export PATH="$LINARO_DIR/bin:$PATH"

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
