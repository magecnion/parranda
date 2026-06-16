#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(realpath "$1")
SANDBOX_HOME="$HOME/.local/share/opencode-sandbox/home"
NODE_BIN_DIR=$(dirname "$(command -v pnpm)")
PNPM_HOME="$HOME/.local/share/pnpm"

mkdir -p "$SANDBOX_HOME" "$SANDBOX_HOME/.local/node-bin" "$SANDBOX_HOME/.local/share/pnpm"

exec bwrap \
  --unshare-all \
  --share-net \
  --die-with-parent \
  \
  --ro-bind /usr /usr \
  --ro-bind /bin /bin \
  --ro-bind /lib /lib \
  --ro-bind /lib64 /lib64 \
  --ro-bind /opt /opt \
  \
  --ro-bind /etc/ssl /etc/ssl \
  --ro-bind /etc/ca-certificates /etc/ca-certificates \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --ro-bind /etc/hosts /etc/hosts \
  --ro-bind /etc/nsswitch.conf /etc/nsswitch.conf \
  \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --tmpfs /run \
  \
  --bind "$PROJECT" /working-dic \
  --bind "$SANDBOX_HOME" /home/sandbox \
  --ro-bind "$HOME/.opencode/bin" /home/sandbox/.opencode/bin \
  --ro-bind "$NODE_BIN_DIR" /home/sandbox/.local/node-bin \
  --ro-bind "$PNPM_HOME" /home/sandbox/.local/share/pnpm \
  --ro-bind "$OC_SKILLS" /home/sandbox/.config/opencode/skills \
  --ro-bind "$OF_ROOT" /home/sandbox/openFrameworks \
  \
  --chdir /working-dic \
  --setenv HOME /home/sandbox \
  --setenv USER sandbox \
  --setenv OF_ROOT /home/sandbox/openFrameworks \
  --setenv PATH /home/sandbox/.local/node-bin:/home/sandbox/.local/share/pnpm:/home/sandbox/.local/share/pnpm/bin:/home/sandbox/.opencode/bin:/usr/local/bin:/usr/bin:/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
