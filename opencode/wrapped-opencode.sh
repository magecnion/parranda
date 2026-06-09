#!/usr/bin/env bash
set -euo pipefail

PROJECT="$(realpath /home/user/project)"
SANDBOX_HOME="$HOME/.local/share/opencode-sandbox/home"

mkdir -p "$SANDBOX_HOME"

exec bwrap \
  --unshare-all \
  --share-net \
  --die-with-parent \
  --new-session \
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
  \
  --chdir /working-dic \
  --setenv HOME /home/sandbox \
  --setenv USER sandbox \
  --setenv PATH /home/sandbox/.opencode/bin:/usr/local/bin:/usr/bin:/bin \
  \
  --setenv TERM "$TERM" \
  --setenv COLORTERM "$COLORTERM" \
  --setenv SHELL /bin/bash \
  /bin/bash
# --ro-bind /nix /nix \
# --dir /etc \
# --dir /etc/ssl \
# --dir /etc/ssl/certs \
# --ro-bind /etc/resolv.conf /etc/resolv.conf \
# --ro-bind-try /etc/hosts /etc/hosts \
# --ro-bind-try /etc/nsswitch.conf /etc/nsswitch.conf \
# --ro-bind "$SSL_CERT_FILE" /etc/ssl/certs/ca-certificates.crt \
# --setenv SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt \
# --setenv GIT_SSL_CAINFO /etc/ssl/certs/ca-certificates.crt \
# --setenv CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt \

# bwrap \
#               --ro-bind /nix /nix \
#               --dev /dev \
#               --proc /proc \
#               --bind "$PWD" /working-dir \
#               --chdir /working-dir \
#               --die-with-parent \
#               --share-net \
#               --ro-bind /etc/resolv.conf /etc/resolv.conf \
#               --dir /etc --dir /etc/ssl --dir /etc/ssl/certs \
#               --ro-bind "$SSL_CERT_FILE" /etc/ssl/certs/ca-bundle.crt \
#               --ro-bind "$SSL_CERT_FILE" /etc/ssl/certs/ca-certificates.crt \
#               --setenv SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
#               --setenv GIT_SSL_CAINFO /etc/ssl/certs/ca-bundle.crt \
#               --setenv CURL_CA_BUNDLE /etc/ssl/certs/ca-bundle.crt \
#               bash

#      exec bwrap \
#               --ro-bind /nix /nix \
#               --ro-bind "$MESHTASTIC_PROJECT_ROOT" "$MESHTASTIC_PROJECT_ROOT" \
#               --dev /dev \
#               --proc /proc \
#               --bind "$PWD" /working-dir \
#               --chdir /working-dir \
#               --die-with-parent \
#               --share-net \
#               --ro-bind /etc/resolv.conf /etc/resolv.conf \
#               --dir /etc --dir /etc/ssl --dir /etc/ssl/certs \
#               --ro-bind "$SSL_CERT_FILE" /etc/ssl/certs/ca-bundle.crt \
#               --ro-bind "$SSL_CERT_FILE" /etc/ssl/certs/ca-certificates.crt \
#               --setenv SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt \
#               --setenv GIT_SSL_CAINFO /etc/ssl/certs/ca-bundle.crt \
#               --setenv CURL_CA_BUNDLE /etc/ssl/certs/ca-bundle.crt \
#               --setenv MESHTASTIC_PORT "''${MESHTASTIC_PORT:-}" \
#               "''${PORT_ARGS[@]}" \
#               bash
#
