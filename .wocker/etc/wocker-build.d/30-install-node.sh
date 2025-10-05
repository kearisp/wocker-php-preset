#!/bin/bash

set -e

if [ "$NODE_VERSION" != "" ] && [ "$NODE_VERSION" != "none" ]; then \
    mkdir -p $NVM_DIR; \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | PROFILE="/home/$USER/.bashrc" bash; \
    . "$NVM_DIR/nvm.sh" && \
        nvm alias default $NODE_VERSION && \
        nvm use default; \
    echo "[ -n \"\$(command -v npm)\" ] && . <(npm completion)" >> "/home/$USER/.bashrc"; \
fi
