#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_HOME_DIR="${OPENCODE_HOME_DIR:-$SCRIPT_DIR/node}"

IMAGE_NAME="kopencode:latest"
STORAGE_DIR="$OPENCODE_HOME_DIR/.local/share/opencode"
CONFIG_DIR="$OPENCODE_HOME_DIR/.config/opencode"
RUSTUP_DIR="$OPENCODE_HOME_DIR/.rustup"
CARGO_DIR="$OPENCODE_HOME_DIR/.cargo"

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-app>"
    exit 1
fi

APP=$(realpath "$1")

echo "docker run -it --rm \\"
echo "  -v \"$STORAGE_DIR\":/home/node/.local/share/opencode \\"
echo "  -v \"$CONFIG_DIR\":/home/node/.config/opencode \\"
echo "  -v \"$RUSTUP_DIR\":/home/node/.rustup \\"
echo "  -v \"$CARGO_DIR\":/home/node/.cargo \\"
echo "  -v \"$APP\":/app/ \\"
echo "  \"$IMAGE_NAME\""
echo
echo "# Tip: add extra docker flags on the line above the image name."
