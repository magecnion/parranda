FROM node:24-slim

ARG LOCAL_TOOLS="git curl nano make zip unzip less gh jq"
RUN apt-get update && apt-get install -y --no-install-recommends \
  ${LOCAL_TOOLS} ca-certificates gcc libc6-dev && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /home/node/app

# rust / npm / pnpm data
RUN mkdir -p \
  /home/node/.cargo \
  /home/node/.rustup \
  /home/node/.npm-global \
  /home/node/.local/share/pnpm/bin && \
  chown -R node:node \
  /home/node/.cargo \
  /home/node/.rustup \
  /home/node/.npm-global \
  /home/node/.local

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV CARGO_HOME=/home/node/.cargo
ENV RUSTUP_HOME=/home/node/.rustup

# Seguridad npm/pnpm
ENV NPM_CONFIG_IGNORE_SCRIPTS=true
ENV PNPM_HOME=/home/node/.local/share/pnpm
ENV PATH=$PNPM_HOME/bin:$PNPM_HOME:$NPM_CONFIG_PREFIX/bin:$CARGO_HOME/bin:$PATH

RUN corepack enable && corepack prepare pnpm@11 --activate

USER node

# rust installation
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN rustup component add clippy rustfmt rust-analyzer

CMD ["/bin/bash"]
