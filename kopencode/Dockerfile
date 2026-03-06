FROM node:23-slim

ARG LOCAL_TOOLS="git curl nano make zip unzip less"
ARG OPENCODE_VERSION=latest
ARG CACHE_BUST

RUN apt-get update && apt-get install -y --no-install-recommends \
  ${LOCAL_TOOLS} ca-certificates gcc libc6-dev && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN chown -R node:node /app

# opencode state
RUN mkdir -p /home/node/.local/share/opencode /home/node/.config/opencode
RUN chown -R node:node /home/node/.local /home/node/.config/opencode

# rust state
RUN mkdir -p /home/node/.cargo /home/node/.rustup
RUN chown -R node:node /home/node/.cargo /home/node/.rustup

USER node

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV CARGO_HOME=/home/node/.cargo
ENV RUSTUP_HOME=/home/node/.rustup
ENV PATH=$NPM_CONFIG_PREFIX/bin:$CARGO_HOME/bin:$PATH

# rust installation
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN rustup component add clippy rustfmt rust-analyzer

# opencode installation
RUN sh -c 'echo "cache bust: ${CACHE_BUST:-cached}" >/tmp/opencode-cache-bust && npm install -g opencode-ai@${OPENCODE_VERSION}'

CMD ["/bin/bash"]
