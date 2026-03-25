FROM node:23-slim

ARG LOCAL_TOOLS="git curl nano make zip unzip less gh jq"
RUN apt-get update && apt-get install -y --no-install-recommends \
  ${LOCAL_TOOLS} ca-certificates gcc libc6-dev && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /home/node/app

# rust data
RUN mkdir -p /home/node/.cargo /home/node/.rustup && \
  chown -R node:node /home/node/.cargo /home/node/.rustup

USER node

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV CARGO_HOME=/home/node/.cargo
ENV RUSTUP_HOME=/home/node/.rustup
ENV PATH=$NPM_CONFIG_PREFIX/bin:$CARGO_HOME/bin:$PATH

# rust installation
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
RUN rustup component add clippy rustfmt rust-analyzer

CMD ["/bin/bash"]
