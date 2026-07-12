#!/bin/sh

set -e

chown -R $USER:$USER /home/$USER

docker-php-source delete

if grep -q "Alpine" /etc/os-release; then
    rm -rf /var/cache/apk/*
else
    rm -rf /var/lib/apt/lists/*
fi
