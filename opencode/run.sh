#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_HOME_DIR="${OPENCODE_HOME_DIR:-$SCRIPT_DIR/node}"

IMAGE_NAME="opencode:latest"
STORAGE_DIR="$OPENCODE_HOME_DIR/.local/share/opencode"
STATE_DIR="$OPENCODE_HOME_DIR/.local/state/opencode"
CONFIG_DIR="$OPENCODE_HOME_DIR/.config/opencode"
# RUSTUP_DIR="$OPENCODE_HOME_DIR/.rustup"
# CARGO_DIR="$OPENCODE_HOME_DIR/.cargo"

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-app>"
    exit 1
fi

mkdir -p \
  "$STORAGE_DIR" \
  "$STATE_DIR" \
  "$CONFIG_DIR"

APP=$(realpath "$1")

exec docker run -it --rm \
  --memory=4g \
  --cpus=2 \
  -v "$STORAGE_DIR:/home/node/.local/share/opencode" \
  -v "$STATE_DIR:/home/node/.local/state/opencode" \
  -v "$CONFIG_DIR:/home/node/.config/opencode" \
  -v "$APP:/home/node/app/" \
  "$IMAGE_NAME"
