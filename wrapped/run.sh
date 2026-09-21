#!/usr/bin/env bash
set -euo pipefail

PROJECT=$(realpath "$1")
SANDBOX_HOME="/home/sandbox"

# OpenCode
OC_HOME="$HOME/.opencode"
OC_SKILLS=$PARRANDA/skills
OC_AGENTS=$PARRANDA/agents
OC_PLUGINS=$PARRANDA/plugins
OC_COMMANDS=$PARRANDA/commands
OC_SANDBOX_HOME="$HOME/.local/share/opencode/sandbox/home"
OC_USER_DATA="$OC_SANDBOX_HOME/.local/share/opencode"

# projects specific: openFrameworks
OPEN_FRAMEWORKS=${2:-}
OPEN_FRAMEWORKS_ARGS=()

if [[ -n "$OPEN_FRAMEWORKS" ]]; then
  OPEN_FRAMEWORKS_ARGS=(
    --ro-bind "$OPEN_FRAMEWORKS" "$SANDBOX_HOME/openFrameworks"
  )
fi

# node
PNPM_HOME="$HOME/.local/share/pnpm"
NODE_HOME=$(dirname "$(dirname "$(readlink -f "$(command -v node)")")")
NPX_HOME="$NODE_HOME/bin/npx"

# rust
CARGO_HOME="$HOME/.cargo"
RUSTUP_HOME="$HOME/.rustup"

mkdir -p "$OC_USER_DATA"

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
  --ro-bind "$PARRANDA/wrapped/bashrc" "$SANDBOX_HOME/.bashrc" \
  \
  --bind "$OC_USER_DATA" "$SANDBOX_HOME/.local/share/opencode" \
  --ro-bind "$OC_HOME/bin" "$SANDBOX_HOME/.opencode/bin" \
  --ro-bind "$PARRANDA/wrapped/AGENTS.md" "$SANDBOX_HOME/.config/opencode/AGENTS.md" \
  --ro-bind "$PARRANDA/wrapped/opencode.jsonc" "$SANDBOX_HOME/.config/opencode/opencode.jsonc" \
  --ro-bind "$OC_SKILLS" "$SANDBOX_HOME/.config/opencode/skills" \
  --ro-bind "$OC_PLUGINS" "$SANDBOX_HOME/.config/opencode/plugins" \
  --ro-bind "$OC_AGENTS" "$SANDBOX_HOME/.config/opencode/agents" \
  --ro-bind "$OC_COMMANDS" "$SANDBOX_HOME/.config/opencode/commands" \
  \
  --ro-bind "$CARGO_HOME" "$SANDBOX_HOME/.cargo" \
  --ro-bind "$RUSTUP_HOME" "$SANDBOX_HOME/.rustup" \
  --ro-bind "$PNPM_HOME" "$SANDBOX_HOME/.local/share/pnpm" \
  --ro-bind "$NODE_HOME" "$SANDBOX_HOME/.local/node" \
  \
  "${OPEN_FRAMEWORKS_ARGS[@]}" \
  \
  --chdir /working-dir \
  --setenv HOME "$SANDBOX_HOME" \
  --setenv USER sandbox \
  --setenv OF_ROOT "${OPEN_FRAMEWORKS:+$SANDBOX_HOME/openFrameworks}" \
  --setenv PATH /usr/local/bin:/usr/bin:/bin:/home/sandbox/.cargo/bin:/home/sandbox/.local/node/bin:/home/sandbox/.local/share/pnpm:/home/sandbox/.local/share/pnpm/bin:/home/sandbox/.opencode/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
