#!/bin/sh

set -e

is_enabled() {
    local value="$1" found=1

    OLD_IFS=$IFS
    IFS=','

    for ext in $PHP_EXTENSIONS; do
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

if is_enabled "pdo_mysql"; then
    docker-php-ext-install pdo pdo_mysql
    docker-php-ext-enable pdo_mysql
fi

if is_enabled "mysqli"; then
    docker-php-ext-install -j "$(nproc)" mysqli
    docker-php-ext-enable mysqli
fi

if is_enabled "pgsql" || is_enabled "pdo_pgsql"; then
    apt-get install -y libpq-dev

    if is_enabled "pgsql"; then
        docker-php-ext-configure pgsql
        docker-php-ext-install pgsql
        docker-php-ext-enable pgsql
    fi

    if is_enabled "pdo_pgsql"; then
        docker-php-ext-install pdo pdo_pgsql
        docker-php-ext-enable pdo_pgsql
    fi
fi

if is_enabled "http"; then
    apt-get install -y \
        libpcre2-dev \
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

if is_enabled "gd"; then
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

if is_enabled "zip"; then
    apt-get install -y libzip-dev zip unzip
    (compare-version $PHP_VERSION "7.3" && docker-php-ext-configure zip || docker-php-ext-configure zip --with-libzip)
    docker-php-ext-install -j "$(nproc)" zip
fi

if is_enabled "memcache"; then
    apt-get install -y \
        zlib1g-dev \
        libmemcached-dev
    pecl install memcache && docker-php-ext-enable memcache
fi

if is_enabled "memcached"; then
    apt-get install -y \
        libcurl4-openssl-dev \
        libssl-dev \
        libmemcached-dev \
        zlib1g-dev
    pecl install memcached && docker-php-ext-enable memcached
fi

if is_enabled "intl"; then
    apt-get install -y libicu-dev
    docker-php-ext-configure intl
    docker-php-ext-install intl
fi

if is_enabled "pcntl"; then
    docker-php-ext-install pcntl
    docker-php-ext-enable pcntl
fi

if is_enabled "soap"; then
    apt-get install -y libxml2-dev
    docker-php-ext-install soap
    docker-php-ext-enable soap
fi

if is_enabled "xdebug"; then
    pecl install xdebug
    docker-php-ext-enable xdebug
    echo "xdebug.mode=${XDEBUG_MODE:-off}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

if is_enabled "uopz"; then
    pecl install uopz
    docker-php-ext-enable uopz
fi

if is_enabled "gettext"; then
    apt-get install -y gettext
    docker-php-ext-install -j "$(nproc)" gettext
    docker-php-ext-enable gettext
fi

if is_enabled "bcmath"; then
    docker-php-ext-install -j "$(nproc)" bcmath
    docker-php-ext-enable bcmath
fi

if is_enabled "sockets"; then
    docker-php-ext-install sockets
    docker-php-ext-enable sockets
fi

if is_enabled "imagick"; then
    apt-get install -y --no-install-recommends \
        libmagickwand-dev
    pecl install imagick
    docker-php-ext-enable imagick
    rm -rf /var/lib/apt/lists/*
fi

if is_enabled "redis"; then
    pecl install redis
    docker-php-ext-enable redis
    rm -rf /var/lib/apt/lists/*
fi

if is_enabled "ldap"; then
    apt-get install -y libldap2-dev
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
    docker-php-ext-install ldap
    rm -rf /var/lib/apt/lists/*
fi

if is_enabled "mongodb"; then
    pecl install mongodb
    docker-php-ext-enable mongodb
    rm -rf /var/lib/apt/lists/*
fi
