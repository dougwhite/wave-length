#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"
README_SRC="$PROJECT_ROOT/README.md"
README_OUT="$BUILD_DIR/_readme_md.html"

# Ensure the build directories are present
mkdir -p "$BUILD_DIR/wave-length-linux" \
         "$BUILD_DIR/wave-length-windows" \
         "$BUILD_DIR/wave-length-web"

# Export the build files
godot --headless --path "$PROJECT_ROOT" --export-release "Linux"            "$BUILD_DIR/wave-length-linux/wave-length.x86_64"
godot --headless --path "$PROJECT_ROOT" --export-release "Windows Desktop"  "$BUILD_DIR/wave-length-windows/wave-length.exe"
godot --headless --path "$PROJECT_ROOT" --export-release "Web"              "$BUILD_DIR/wave-length-web/index.html"

# Push to itch.io with butler
butler push wave-length-linux pooglies/wave-length:linux
butler push wave-length-windows pooglies/wave-length:windows
butler push wave-length-web pooglies/wave-length:web

# Generate a html version of the readme, for pasting into itch.io project descriptions
pandoc "$README_SRC" -f markdown-smart -t html -o "$README_OUT"