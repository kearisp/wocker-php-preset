#!/bin/sh

set -e

case "$NODE_PACKAGE_MANAGER" in
    "pnpm")
        npm install -g pnpm
        ;;
esac
