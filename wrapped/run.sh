#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(realpath "$1")

# OpenCode
OC_HOME="$HOME/.opencode"
OC_SKILLS=$PARRANDA/skills
OC_AGENTS=$PARRANDA/agents
OC_COMMANDS=$PARRANDA/commands
OC_SANDBOX_HOME="$HOME/.local/share/opencode-sandbox/home"

# projects specific (this should be provided on the run) TODO
OPEN_FRAMEWORKS=/home/carla/dev/magecnion/oss/openFrameworks

# node
PNPM_HOME="$HOME/.local/share/pnpm"
NODE_HOME=$(dirname "$(dirname "$(readlink -f "$(command -v node)")")")
NPX_HOME="$NODE_HOME/bin/npx"

# rust
CARGO_HOME="$HOME/.cargo"
RUSTUP_HOME="$HOME/.rustup"

mkdir -p "$OC_SANDBOX_HOME"

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
  --bind "$PROJECT" /working-dir \
  --bind "$OC_SANDBOX_HOME" /home/sandbox \
  \
  --ro-bind "$OC_HOME/bin" /home/sandbox/.opencode/bin \
  --ro-bind "$PARRANDA/wrapped/AGENTS.md" /home/sandbox/.config/opencode/AGENTS.md \
  --ro-bind "$PARRANDA/wrapped/opencode.jsonc" /home/sandbox/.config/opencode/opencode.jsonc \
  --ro-bind "$OC_SKILLS" /home/sandbox/.config/opencode/skills \
  --ro-bind "$OC_AGENTS" /home/sandbox/.config/opencode/agents \
  --ro-bind "$OC_COMMANDS" /home/sandbox/.config/opencode/commands \
  \
  --ro-bind "$CARGO_HOME" /home/sandbox/.cargo \
  --ro-bind "$RUSTUP_HOME" /home/sandbox/.rustup \
  --ro-bind "$PNPM_HOME" /home/sandbox/.local/share/pnpm \
  --ro-bind "$NODE_HOME" /home/sandbox/.local/node \
  \
  --ro-bind "$OPEN_FRAMEWORKS" /home/sandbox/openFrameworks \
  \
  --chdir /working-dir \
  --setenv HOME /home/sandbox \
  --setenv USER sandbox \
  --setenv OPEN_FRAMEWORKS /home/sandbox/openFrameworks \
  --setenv CARGO_HOME /home/sandbox/.cargo \
  --setenv RUSTUP_HOME /home/sandbox/.rustup \
  --setenv PATH /usr/local/bin:/usr/bin:/bin:/home/sandbox/.cargo/bin:/home/sandbox/.local/node/bin:/home/sandbox/.local/share/pnpm:/home/sandbox/.opencode/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
