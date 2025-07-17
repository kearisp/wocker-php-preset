#!/bin/bash

PHP_VERSION=$(php -r "echo phpversion();")

if [ "$HTTP_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        libpcre3-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        g++ \
        zlib1g-dev && \
    docker-php-ext-install pcntl && \
    pecl install raphf && docker-php-ext-enable raphf && \
    pecl install pecl_http && docker-php-ext-enable http; \
fi

if [ "$MYSQLI_ENABLE" = "true" ]; then \
    docker-php-ext-install -j "$(nproc)" mysqli && \
    docker-php-ext-enable mysqli; \
fi

if [ "$PDO_MYSQL_ENABLE" = "true" ]; then \
    docker-php-ext-install pdo pdo_mysql &&  \
    docker-php-ext-enable pdo_mysql; \
fi

if [ "$GD_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev && \
    compare-version $PHP_VERSION "7.3" && \
        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include || \
        docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install exif; \
fi

if [ "$ZIP_ENABLE" = "true" ]; then \
    apt-get install -y libzip-dev zip unzip && \
    (compare-version $PHP_VERSION "7.3" && docker-php-ext-configure zip || docker-php-ext-configure zip --with-libzip) && \
    docker-php-ext-install -j "$(nproc)" zip; \
fi

if [ "$MEMCACHE_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        zlib1g-dev \
        libmemcached-dev && \
    pecl install memcache && docker-php-ext-enable memcache; \
fi

if [ "$MEMCACHED_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        libcurl4-openssl-dev  \
        libssl-dev \
        libmemcached-dev \
        zlib1g-dev && \
    pecl install memcached && docker-php-ext-enable memcached; \
fi

if [ "$INTL_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        libicu-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl; \
fi

if [ "$PCNTL_ENABLE" = "true" ]; then \
    docker-php-ext-install pcntl && \
    docker-php-ext-enable pcntl; \
fi

if [ "$SOAP_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y \
        libxml2-dev && \
    docker-php-ext-install soap && \
    docker-php-ext-enable soap; \
fi

if [ "$XDEBUG_ENABLE" = "true" ]; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug; \
fi

if [ "$GETTEXT_ENABLE" = "true" ]; then \
    apt-get update && apt-get install -y gettext && \
    docker-php-ext-install -j "$(nproc)" gettext && \
    docker-php-ext-enable gettext; \
fi

if [ "$BCMATH_ENABLE" = "true" ]; then \
    docker-php-ext-install -j "$(nproc)" bcmath && \
    docker-php-ext-enable bcmath; \
fi

if [ "$SOCKETS_ENABLE" = "true" ]; then \
    docker-php-ext-install sockets && \
    docker-php-ext-enable sockets; \
fi
