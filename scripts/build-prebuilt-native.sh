#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$(cd "$ROOT/.." && pwd)/android-build"
APK="$ROOT/../OpenMemories-Tweak-release-0.11.apk"
PREBUILT="$ROOT/app/src/main/prebuilt-jniLibs"

if [ ! -f "$APK" ]; then
  echo "Missing upstream release APK: $APK" >&2
  exit 1
fi

rm -rf "$PREBUILT"
mkdir -p "$PREBUILT"
unzip -oq "$APK" 'lib/armeabi/*.so' -d "$PREBUILT"
mv "$PREBUILT/lib/armeabi" "$PREBUILT/armeabi"
rmdir "$PREBUILT/lib"

cat > "$ROOT/local.properties" <<EOF
sdk.dir=$TOOLS_DIR/android-sdk
ndk.dir=$TOOLS_DIR/android-ndk-r14b
EOF

cd "$ROOT"
GRADLE_USER_HOME="$TOOLS_DIR/gradle-home" \
JAVA_HOME="$TOOLS_DIR/jdk8" \
"$TOOLS_DIR/gradle-4.10.3/bin/gradle" assembleDebug -PusePrebuiltNative --no-daemon --stacktrace
