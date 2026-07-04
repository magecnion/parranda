#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(realpath "$1")
SANDBOX_HOME="$HOME/.local/share/opencode-sandbox/home"
# NODE_BIN_DIR=$(dirname "$(command -v pnpm)")
  # --ro-bind "$NODE_BIN_DIR" /home/sandbox/.local/node-bin \
PNPM_HOME="$HOME/.local/share/pnpm"
NODE_PREFIX=$(dirname "$(dirname "$(readlink -f "$(command -v node)")")")
CARGO_HOME="$HOME/.cargo"
RUSTUP_HOME="$HOME/.rustup"
NPX_HOME="$HOME/.nvm/versions/node/v24.16.0/bin/npx"

mkdir -p "$SANDBOX_HOME" "$SANDBOX_HOME/.local/share/pnpm"

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
  --ro-bind "$CARGO_HOME" /home/sandbox/.cargo \
  --ro-bind "$RUSTUP_HOME" /home/sandbox/.rustup \
  --ro-bind "$PNPM_HOME" /home/sandbox/.local/share/pnpm \
  --ro-bind "$NODE_PREFIX" /home/sandbox/.local/node \
  --ro-bind-try "$PROJECT/wrapped/AGENTS.md" /home/sandbox/.config/opencode/AGENTS.md \
  --ro-bind-try "$PROJECT/wrapped/opencode.jsonc" /home/sandbox/.config/opencode/opencode.jsonc \
  --ro-bind "$OC_SKILLS" /home/sandbox/.config/opencode/skills \
  --ro-bind "$OC_AGENTS" /home/sandbox/.config/opencode/agents \
  --ro-bind "$OC_COMMANDS" /home/sandbox/.config/opencode/commands \
  --ro-bind "$OF_ROOT" /home/sandbox/openFrameworks \
  \
  --chdir /working-dic \
  --setenv HOME /home/sandbox \
  --setenv USER sandbox \
  --setenv OF_ROOT /home/sandbox/openFrameworks \
  --setenv CARGO_HOME /home/sandbox/.cargo \
  --setenv RUSTUP_HOME /home/sandbox/.rustup \
  --setenv PATH /home/sandbox/.cargo/bin:/home/sandbox/.local/node/bin:/home/sandbox/.local/share/pnpm:/home/sandbox/.local/share/pnpm/bin:/home/sandbox/.opencode/bin:/usr/local/bin:/usr/bin:/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
