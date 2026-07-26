#!/usr/bin/env sh
set -o errexit -o nounset

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

SRC_DIR="$PROJECT_ROOT/extension/src"
TARGET_DIR="$PROJECT_ROOT/target"
BUILD_DIR="$PROJECT_ROOT/.build"

EXTENSION_NAME="script-blocker"
XPI_FILE="$TARGET_DIR/${EXTENSION_NAME}.xpi"

echo "Project root: $PROJECT_ROOT"

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: missing src directory: $SRC_DIR"
    exit 1
fi

mkdir -p "$TARGET_DIR"

rm -rf "$BUILD_DIR"
rm -f "$XPI_FILE"

mkdir -p "$BUILD_DIR"

cp -r "$SRC_DIR"/* "$BUILD_DIR"/

(
    cd "$BUILD_DIR"
    zip -r "$XPI_FILE" .
)

rm -rf "$BUILD_DIR"

echo
echo "Created extension:"
echo "$XPI_FILE"
