FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
RUN mkdir /app
WORKDIR /app

# Clone the repository
ARG GITHUB_TOKEN
RUN git clone https://${GITHUB_TOKEN}@github.com/issue-invention/636561929.git .
RUN LATEST_COMMIT=$(git rev-list -n 1 HEAD) && git reset --hard $LATEST_COMMIT

# Install project dependencies
RUN cd app && npm install --legacy-peer-deps

# Install testing dependencies
RUN cd app && npm install -D vitest

ENTRYPOINT ["/bin/bash"]
