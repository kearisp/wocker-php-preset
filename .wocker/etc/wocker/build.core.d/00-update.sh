#!/bin/sh

set -e

if grep -q "Alpine" /etc/os-release; then
    apk update
    apk add --no-cache \
        curl \
        git \
        build-base \
        openssl-dev \
        zlib-dev \
        shadow
else
    apt-get update --fix-missing -y
    apt-get install -y \
        curl \
        git \
        build-essential \
        libssl-dev \
        zlib1g-dev
fi

mkdir -p /home/$USER
usermod -d /home/$USER -u $UID -s /bin/sh $USER

touch /home/$USER/.bashrc
touch /home/$USER/.profile
