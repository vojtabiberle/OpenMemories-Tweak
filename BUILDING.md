# Building OpenMemories Tweak

This fork currently has two build paths:

- `usePrebuiltNative`: builds the Java/APK layer and packages native files copied from the upstream release APK.
- legacy native build: rebuilds the native Android libraries and the Linux `protectiontweak` executable.

The goal is to make the legacy native build reproducible on a current host while keeping the old toolchain versions pinned.

## Current Status

Verified locally:

- Java/Android build works with Gradle 4.10.3 and JDK 8.
- Android native build works with Android NDK r14b.
- NDK r16 is too new for this project:
  - it treats `android-9` as unsupported and uses `android-14`
  - that breaks the old Android 2.3 `adbd` sources, starting with missing `prop_msg`
- The release APK native files match the expected split:
  - `libtweak.so`: Android shared library, built by NDK r14b
  - `libadbd.so`: Android executable renamed to a library, built by NDK r14b
  - `libprotectiontweak.so`: GNU/Linux ARM executable renamed to a library, not built by Android NDK

Still required for a full native build:

- Linaro `arm-linux-gnueabi` GCC 4.9.4 from `4.9-2017.01`
- The command names `arm-linux-gnueabi-gcc` and `arm-linux-gnueabi-g++` must be on `PATH`

The upstream build file points at:

```text
https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabi/
```

Expected archive name:

```text
gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi.tar.xz
```

At the time this note was written, `releases.linaro.org` was not reachable from the local environment, so the Linaro step is documented but not yet automated end-to-end.

## One-Time Setup

From this repository:

```sh
scripts/setup-ndk-r14b.sh
```

This downloads Android NDK r14b from Google into `../android-build` and verifies the archive checksum.

Then install or unpack the Linaro `arm-linux-gnueabi` toolchain and put its `bin` directory on `PATH`.

Example:

```sh
export PATH="$PWD/../android-build/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin:$PATH"
```

Check:

```sh
arm-linux-gnueabi-gcc --version
arm-linux-gnueabi-g++ --version
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
- Linaro `arm-linux-gnueabi` GCC on `PATH`

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
