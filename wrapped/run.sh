#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(realpath "$1")
SANDBOX_HOME="$HOME/.local/share/opencode-sandbox/home"

mkdir -p "$SANDBOX_HOME"

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
  --ro-bind "$OC_SKILLS" /home/sandbox/.config/opencode/skills \
  --ro-bind "$OF_ROOT" /home/sandbox/openFrameworks \
  \
  --chdir /working-dic \
  --setenv HOME /home/sandbox \
  --setenv USER sandbox \
  --setenv OF_ROOT /home/sandbox/openFrameworks \
  --setenv PATH /home/sandbox/.opencode/bin:/usr/local/bin:/usr/bin:/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
