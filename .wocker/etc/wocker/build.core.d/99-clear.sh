#!/bin/sh

set -e

if grep -q "Alpine" /etc/os-release; then
    rm -rf /var/cache/apk/*
else
    rm -rf /var/lib/apt/lists/*
fi
