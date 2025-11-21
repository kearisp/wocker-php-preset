#!/bin/sh

set -e

if [ "$INSTALL_BASH" != "true" ]; then
    exit 0
fi

if command -v bash >/dev/null 2>&1; then
    echo "Bash is already installed: $(bash --version | head -n 1)"
    exit 0
fi

echo "Bash not found. Installing..."

if grep -q "Alpine" /etc/os-release; then
    apk add --no-cache bash || {
        echo "Failed to install bash package on Alpine"
        exit 1
    }
else
    apt-get install -y bash || {
        echo "Failed to install bash package on Debian/Ubuntu"
        exit 1
    }
fi

echo "Bash successfully installed"
