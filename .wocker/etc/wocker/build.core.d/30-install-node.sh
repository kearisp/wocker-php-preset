#!/bin/sh

set -e

if [ "$NODE_VERSION" != "" ]; then
    mkdir -p $NVM_DIR
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE="/home/$USER/.bashrc" bash
fi
