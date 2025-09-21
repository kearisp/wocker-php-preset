#!/bin/sh

set -e

# Install timezone data package for proper time handling
if grep -q "Alpine" /etc/os-release; then
    apk add --no-cache tzdata || {
        echo "Failed to install tzdata package on Alpine"
        exit 1
    }
else
    apt-get install -y tzdata || {
        echo "Failed to install tzdata package on Debian/Ubuntu"
        exit 1
    }
fi