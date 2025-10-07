#!/bin/sh

set -e

if [ "$NODE_VERSION" = "" ]; then
    echo "No node version found"
    exit 0
fi

if [ -f "package.json" ] && { [ ! -d "node_modules" ] || [ "package.json" -nt "node_modules" ]; }; then
    case "$NODE_PACKAGE_MANAGER" in
        "npm")
            if [ -f "package-lock.json" ]; then
                npm ci --quiet --no-progress
            else
                npm install --quiet --no-progress
            fi
            ;;
        "pnpm")
            if [ -f "pnpm-lock.yaml" ]; then
                pnpm install --frozen-lockfile --silent
            else
                pnpm install --silent
            fi
            ;;
        "yarn")
            yarn install --silent
            ;;
        *)
            echo "Error: Invalid package manager name '$NODE_PACKAGE_MANAGER'"
            exit 1
            ;;
    esac
fi
