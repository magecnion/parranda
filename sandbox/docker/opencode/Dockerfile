FROM agent-base

# weird behaviour was observed terminal formatting related if followings lines are not present
# opencode data
RUN mkdir -p /home/node/.local/share/opencode /home/node/.config/opencode

# opencode installation
ARG CACHE_BUST
ARG OPENCODE_VERSION=1.18.10

ENV PNPM_HOME=/home/node/.local/share/pnpm
ENV PATH=$PNPM_HOME/bin:$PNPM_HOME:$PATH

RUN pnpm add -g --allow-build=opencode-ai "opencode-ai@${OPENCODE_VERSION}"

CMD ["bash"]
