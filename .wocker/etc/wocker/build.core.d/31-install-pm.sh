#!/bin/sh

set -e

if [ "$NODE_VERSION" != "" ]; then
    case "$NODE_PACKAGE_MANAGER" in
        "pnpm")
            npm install -g pnpm
            ;;

        "yarn")
            npm install -g yarn
            ;;
    esac
fi
