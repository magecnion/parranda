#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDECODE_HOME_DIR="${CLAUDECODE_HOME_DIR:-$SCRIPT_DIR/node}"

IMAGE_NAME="claudecode:latest"
CONFIG_DIR="$CLAUDECODE_HOME_DIR/.claude"
CONFIG_FILE="$CLAUDECODE_HOME_DIR/.claude.json"

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-app>"
    exit 1
fi

mkdir -p \
  "$CONFIG_DIR"
touch "$CONFIG_FILE"

APP=$(realpath "$1")

exec docker run -it --rm \
  --memory=4g \
  --cpus=2 \
  -v "$CONFIG_DIR:/home/node/.claude" \
  -v "$CONFIG_FILE:/home/node/.claude.json" \
  -v "$APP:/home/node/app/" \
  "$IMAGE_NAME"
