#!/bin/bash

set -e

is_enabled() {
    local value="$1" found=1

    OLD_IFS=$IFS
    IFS=','

    for ext in $EXTENSIONS; do
        if [ "$ext" = "$value" ]; then
            found=0
            break
        fi
    done

    IFS=$OLD_IFS

    return $found
}

PHP_VERSION=$(php -r "echo phpversion();")

a2enmod rewrite
a2enmod headers

apt-get update

if [ "$PDO_MYSQL_ENABLE" = "true" ] || is_enabled "PDO_MYSQL_ENABLE"; then
    docker-php-ext-install pdo pdo_mysql
    docker-php-ext-enable pdo_mysql
fi

if [ "$MYSQLI_ENABLE" = "true" ] || is_enabled "MYSQLI_ENABLE"; then
    docker-php-ext-install -j "$(nproc)" mysqli
    docker-php-ext-enable mysqli
fi

if [ "$HTTP_ENABLE" = "true" ] || is_enabled "HTTP_ENABLE"; then
    apt-get install -y \
        libpcre3-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        g++ \
        zlib1g-dev
    docker-php-ext-install pcntl
    pecl install raphf
    docker-php-ext-enable raphf
    pecl install pecl_http
    docker-php-ext-enable http
fi

if [ "$GD_ENABLE" = "true" ] || is_enabled "GD_ENABLE"; then
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev
    compare-version $PHP_VERSION "7.3" && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include || \
        docker-php-ext-configure gd --with-freetype --with-jpeg
    docker-php-ext-install -j$(nproc) gd
    docker-php-ext-enable gd
    docker-php-ext-install exif
    docker-php-ext-enable exif
fi

if [ "$ZIP_ENABLE" = "true" ] || is_enabled "ZIP_ENABLE"; then
    apt-get install -y libzip-dev zip unzip
    (compare-version $PHP_VERSION "7.3" && docker-php-ext-configure zip || docker-php-ext-configure zip --with-libzip)
    docker-php-ext-install -j "$(nproc)" zip
fi

if [ "$MEMCACHE_ENABLE" = "true" ] || is_enabled "MEMCACHE_ENABLE"; then
    apt-get install -y \
        zlib1g-dev \
        libmemcached-dev
    pecl install memcache && docker-php-ext-enable memcache
fi

if [ "$MEMCACHED_ENABLE" = "true" ] || is_enabled "MEMCACHED_ENABLE"; then
    apt-get install -y \
        libcurl4-openssl-dev \
        libssl-dev \
        libmemcached-dev \
        zlib1g-dev
    pecl install memcached && docker-php-ext-enable memcached
fi

if [ "$INTL_ENABLE" = "true" ] || is_enabled "INTL_ENABLE"; then
    apt-get install -y libicu-dev
    docker-php-ext-configure intl
    docker-php-ext-install intl
fi

if [ "$PCNTL_ENABLE" = "true" ] || is_enabled "PCNTL_ENABLE"; then
    docker-php-ext-install pcntl
    docker-php-ext-enable pcntl
fi

if [ "$SOAP_ENABLE" = "true" ] || is_enabled "SOAP_ENABLE"; then
    apt-get install -y libxml2-dev
    docker-php-ext-install soap
    docker-php-ext-enable soap
fi

if [ "$XDEBUG_ENABLE" = "true" ] || is_enabled "XDEBUG_ENABLE"; then
    pecl install xdebug
    docker-php-ext-enable xdebug
fi

if [ "$GETTEXT_ENABLE" = "true" ] || is_enabled "GETTEXT_ENABLE"; then
    apt-get install -y gettext
    docker-php-ext-install -j "$(nproc)" gettext
    docker-php-ext-enable gettext
fi

if [ "$BCMATH_ENABLE" = "true" ] || is_enabled "BCMATH_ENABLE"; then
    docker-php-ext-install -j "$(nproc)" bcmath
    docker-php-ext-enable bcmath
fi

if [ "$SOCKETS_ENABLE" = "true" ] || is_enabled "SOCKETS_ENABLE"; then
    docker-php-ext-install sockets
    docker-php-ext-enable sockets
fi

if [ "$IMAGICK_ENABLE" = "true" ] || is_enabled "IMAGICK_ENABLE"; then
    apt-get install -y --no-install-recommends \
        libmagickwand-dev
    pecl install imagick
    docker-php-ext-enable imagick
    rm -rf /var/lib/apt/lists/*
fi

if [ "$REDIS_ENABLE" = "true" ] || is_enabled "REDIS_ENABLE"; then
    pecl install redis
    docker-php-ext-enable redis
    rm -rf /var/lib/apt/lists/*
fi

if [ "$LDAP_ENABLE" = "true" ] || is_enabled "LDAP_ENABLE"; then
    apt-get install -y libldap2-dev
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
    docker-php-ext-install ldap
    rm -rf /var/lib/apt/lists/*
fi

if [ "$MONGODB_ENABLE" = "true" ] || is_enabled "MONGODB_ENABLE"; then
    pecl install mongodb
    docker-php-ext-enable mongodb
    rm -rf /var/lib/apt/lists/*
fi
