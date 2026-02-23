#!/bin/bash
set -e


APP_NAME="Final-Cleanner"
APP_VERSION="1.0.0"
ARCH=$(uname -m)
FLUTTER_ARCH="x64"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/linux/$FLUTTER_ARCH/release"
APPDIR="$PROJECT_ROOT/build/AppDir"
OUTPUT_DIR="$PROJECT_ROOT/build"

echo "==> Building Flutter Linux release..."
cd "$PROJECT_ROOT"
flutter build linux --release

echo "==> Creating AppDir structure..."
rm -rf "$APPDIR"
mkdir -p "$APPDIR"

echo "==> Copying Flutter bundle..."
cp -r "$BUILD_DIR/bundle"/* "$APPDIR/"

echo "==> Adding AppImage metadata..."
cp "$SCRIPT_DIR/AppRun" "$APPDIR/"
cp "$SCRIPT_DIR/final-cleaner.desktop" "$APPDIR/"
cp "$SCRIPT_DIR/final_cleaner.png" "$APPDIR/"

echo "==> Creating AppImage spec symlinks..."
ln -sf final_cleaner.png "$APPDIR/.DirIcon"

echo "==> Downloading appimagetool..."
APPIMAGETOOL="$PROJECT_ROOT/build/appimagetool-$ARCH.AppImage"
if [ ! -f "$APPIMAGETOOL" ]; then
    curl -L -o "$APPIMAGETOOL" \
        "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$ARCH.AppImage"
    chmod +x "$APPIMAGETOOL"
fi

echo "==> Building AppImage..."
cd "$OUTPUT_DIR"
ARCH=$ARCH "$APPIMAGETOOL" "$APPDIR" "$APP_NAME-$APP_VERSION-$ARCH.AppImage"

echo "==> Done!"
echo "AppImage created: $OUTPUT_DIR/$APP_NAME-$APP_VERSION-$ARCH.AppImage"
