# Building OpenMemories Tweak

This fork currently has two build paths:

- `usePrebuiltNative`: builds the Java/APK layer and packages native files copied from the upstream release APK.
- legacy native build: rebuilds the native Android libraries and the Linux `protectiontweak` executable.

The goal is to make the legacy native build reproducible on a current host while keeping the old toolchain versions pinned.

## Current Status

Verified locally:

- Java/Android build works with Gradle 4.10.3 and JDK 8.
- Android native build works with Android NDK r14b.
- Full native build works with Linaro `arm-linux-gnueabi` GCC 4.9.4 from `4.9-2017.01`.
- NDK r16 is too new for this project:
  - it treats `android-9` as unsupported and uses `android-14`
  - that breaks the old Android 2.3 `adbd` sources, starting with missing `prop_msg`
- The release APK native files match the expected split:
  - `libtweak.so`: Android shared library, built by NDK r14b
  - `libadbd.so`: Android executable renamed to a library, built by NDK r14b
  - `libprotectiontweak.so`: GNU/Linux ARM executable renamed to a library, not built by Android NDK

The full native build requires:

- Linaro `arm-linux-gnueabi` GCC 4.9.4 from `4.9-2017.01`
- Android NDK r14b
- JDK 8
- Gradle 4.10.3

The upstream build file points at:

```text
https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/
```

Expected archive name:

```text
gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz
```

Verified archive MD5:

```text
7d409a976ac5bb68fe52b9c1dc503734
```

The setup script uses Armbian mirror fallbacks because `releases.linaro.org` is not reliably reachable.

## One-Time Setup

From this repository:

```sh
scripts/setup-ndk-r14b.sh
scripts/setup-linaro-gnueabi.sh
```

These download Android NDK r14b and the Linaro `arm-linux-gnueabi` toolchain into `../android-build` and verify archive checksums.

Optional check:

```sh
../android-build/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-gcc --version
../android-build/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-g++ --version
```

## Full Legacy Build

```sh
scripts/build-debug.sh
```

This build requires:

- JDK 8 at `../android-build/jdk8`
- Gradle 4.10.3 at `../android-build/gradle-4.10.3`
- Android SDK at `../android-build/android-sdk`
- Android NDK r14b at `../android-build/android-ndk-r14b`
- Linaro `arm-linux-gnueabi` GCC at `../android-build/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi`

Expected native outputs in the APK:

```text
lib/armeabi/libadbd.so
lib/armeabi/libprotectiontweak.so
lib/armeabi/libtweak.so
```

## Android Native Diagnostic Build

To verify only the Android NDK part:

```sh
scripts/build-android-native-only.sh
```

This intentionally skips `runMake`, so the generated APK does not contain `libprotectiontweak.so`. It is useful for confirming that the r14b NDK path can build `libtweak.so` and `adbd`.

## Prebuilt Native Build

For testing Java/lifecycle changes without rebuilding native code:

```sh
scripts/build-prebuilt-native.sh
```

This extracts native files from `../OpenMemories-Tweak-release-0.11.apk` and builds with `-PusePrebuiltNative`.

Use this only when the native code has not changed.
