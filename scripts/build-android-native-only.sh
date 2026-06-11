#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"

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
"$TOOLS_DIR/gradle-4.10.3/bin/gradle" assembleDebug -x runMake --no-daemon --stacktrace

echo "Built Android native diagnostic APK. It intentionally does not contain libprotectiontweak.so."
