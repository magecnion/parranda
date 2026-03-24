FROM agent-base

# weird behaviour was observed terminal formatting related if followings lines are not present
# opencode data
RUN mkdir -p /home/node/.local/share/opencode /home/node/.config/opencode

# opencode installation
ARG CACHE_BUST
ARG OPENCODE_VERSION=latest
RUN npm install -g "opencode-ai@${OPENCODE_VERSION}"

CMD ["opencode"]
