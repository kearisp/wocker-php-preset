#!/bin/sh

set -e

if grep -q "Alpine" /etc/os-release; then
    apk update
    apk add --no-cache \
        curl \
        git \
        build-base \
        openssl-dev \
        zlib-dev
else
    apt-get update --fix-missing -y
    apt-get install -y \
        curl \
        git \
        build-essential \
        libssl-dev \
        zlib1g-dev
fi
