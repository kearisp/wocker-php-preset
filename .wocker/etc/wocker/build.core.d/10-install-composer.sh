#!/bin/sh

set -e

if [ "$COMPOSER_ENABLE" = "true" ]; then \
    apt-get update && \
        apt-get install -y bash-completion; \
    echo "source /etc/bash_completion" >> /home/$USER/.bashrc; \
    mkdir -p /home/$USER/.composer; \
    curl -sL https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer; \
    echo ". <(composer completion bash)" >> /home/$USER/.bashrc; \
fi
