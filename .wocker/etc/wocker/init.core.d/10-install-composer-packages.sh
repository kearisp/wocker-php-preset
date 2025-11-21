#!/bin/sh

set -e

if [ "$COMPOSER_ENABLE" = "true" ]; then
    if [ -f "composer.json" ] && [ ! -d "vendor" ]; then
        composer install --no-interaction --optimize-autoloader
    fi
fi
