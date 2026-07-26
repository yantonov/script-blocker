#!/usr/bin/env sh

set -o errexit -o nounset

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

GENERATOR_DIR="$PROJECT_ROOT/rule-generator"
GENERATOR="$GENERATOR_DIR/target/release/rule-generator"
GENERATOR_BUILD="$GENERATOR_DIR/bin/build.sh"

CONFIG="$PROJECT_ROOT/config.yml"
OUTPUT_DIR="$PROJECT_ROOT/extension/src"

if [ ! -x "$GENERATOR" ]; then
    echo "Generator binary not found:"
    echo "$GENERATOR"

    if [ ! -x "$GENERATOR_BUILD" ]; then
        echo "Error: generator build script not found:"
        echo "$GENERATOR_BUILD"
        exit 1
    fi

    echo "Building generator..."
    "$GENERATOR_BUILD"
fi

if [ ! -f "$CONFIG" ]; then
    echo "Error: config not found:"
    echo "$CONFIG"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Generating rules..."

"$GENERATOR" \
    --config "$CONFIG" \
    --output "$OUTPUT_DIR"

echo "Generated:"
echo "$OUTPUT_DIR/rules.json"
