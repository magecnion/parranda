#!/bin/bash

IMAGE_NAME="opencode:latest"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${OPENCODE_HOME_DIR:-$SCRIPT_DIR/node}"
STORAGE_DIR="$HOME_DIR/.local/share/opencode"
STATE_DIR="$HOME_DIR/.local/state/opencode"
CONFIG_DIR="$HOME_DIR/.config/opencode"

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-project>"
    exit 1
fi

mkdir -p \
  "$STORAGE_DIR" \
  "$STATE_DIR" \
  "$CONFIG_DIR"

PROJECT_PATH=$(realpath "$1")

exec docker run -it --rm \
  --memory=4g \
  --cpus=2 \
  -v "$STORAGE_DIR:/home/node/.local/share/opencode" \
  -v "$STATE_DIR:/home/node/.local/state/opencode" \
  -v "$CONFIG_DIR:/home/node/.config/opencode" \
  -v "$PROJECT_PATH:/home/node/app/" \
  "$IMAGE_NAME"
