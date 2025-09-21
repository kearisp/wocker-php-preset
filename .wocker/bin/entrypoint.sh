#!/bin/bash

set -e

. ~/.bashrc

ws-run-hook init

exec docker-php-entrypoint "$@"
