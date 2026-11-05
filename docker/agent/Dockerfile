
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/agent
ENV PATH="/home/agent/.opencode/bin:/usr/local/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    unzip \
    tar \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --uid 1000 --shell /bin/bash agent \
    && mkdir -p \
        /workspace \
        /home/agent/.config/opencode \
        /home/agent/.local/share/opencode \
    && chown -R agent:agent /workspace /home/agent

USER agent
WORKDIR /workspace

# Install OpenCode V2
RUN curl -fsSL https://opencode.ai/v2/install | bash \
    && opencode --version

CMD ["opencode"]
