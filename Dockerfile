ARG IMAGE_VERSION="8.3-apache"
FROM php:${IMAGE_VERSION}

ARG UID=1000
ARG USER=www-data

ARG EXTENSIONS=""
ARG HTTP_ENABLE=false
ARG MYSQLI_ENABLE=false
ARG PDO_MYSQL_ENABLE=false
ARG PGSQL_ENABLE=false
ARG GD_ENABLE=false
ARG ZIP_ENABLE=false
ARG MEMCACHE_ENABLE=false
ARG MEMCACHED_ENABLE=false
ARG INTL_ENABLE=false
ARG PCNTL_ENABLE=false
ARG SOAP_ENABLE=false
ARG XDEBUG_ENABLE=false
ARG GETTEXT_ENABLE=false
ARG BCMATH_ENABLE=false
ARG SOCKETS_ENABLE=false
ARG NODE_VERSION=''
ARG COMPOSER_ENABLE=false

ENV EXTENSIONS=$EXTENSIONS \
    HTTP_ENABLE=$HTTP_ENABLE \
    MYSQLI_ENABLE=$MYSQLI_ENABLE \
    PDO_MYSQL_ENABLE=$PDO_MYSQL_ENABLE \
    PGSQL_ENABLE=$PGSQL_ENABLE \
    GD_ENABLE=$GD_ENABLE \
    ZIP_ENABLE=$ZIP_ENABLE \
    MEMCACHE_ENABLE=$MEMCACHE_ENABLE \
    MEMCACHED_ENABLE=$MEMCACHED_ENABLE \
    INTL_ENABLE=$INTL_ENABLE \
    PCNTL_ENABLE=$PCNTL_ENABLE \
    SOAP_ENABLE=$SOAP_ENABLE \
    XDEBUG_ENABLE=$XDEBUG_ENABLE \
    GETTEXT_ENABLE=$GETTEXT_ENABLE \
    BCMATH_ENABLE=$BCMATH_ENABLE \
    SOCKETS_ENABLE=$SOCKETS_ENABLE \
    NVM_DIR=/home/$USER/.nvm \
    NODE_VERSION=$NODE_VERSION \
    COMPOSER_ENABLE=$COMPOSER_ENABLE

RUN a2enmod rewrite
RUN a2enmod headers

ADD ./.wocker/bin/entrypoint.sh /usr/local/bin/docker-entrypoint
ADD ./.wocker/bin/compare-version /usr/local/bin/compare-version
ADD ./.wocker/bin/ws-run-hook.sh /usr/local/bin/ws-run-hook
ADD ./.wocker/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./.wocker/etc/apache2/apache2.conf /etc/apache2/apache2.conf
COPY ./.wocker/etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-available/
COPY ./.wocker/etc/wocker-build.d /etc/wocker-build.d

RUN usermod -u $UID -s /bin/bash $USER && \
    mkdir -p /home/$USER && \
    touch /home/$USER/.bashrc && \
    chown -R $USER:$USER /home/$USER && \
    chmod +x /usr/local/bin/compare-version && \
    apt-get update --fix-missing -y && \
    apt-get install -y \
        curl \
        git \
        build-essential \
        libssl-dev \
        zlib1g-dev && \
    chmod 775 /usr/local/bin/docker-entrypoint && \
    chmod +x /usr/local/bin/docker-entrypoint && \
    chmod 775 /usr/local/bin/ws-run-hook && \
    chmod +x /usr/local/bin/ws-run-hook && \
    ws-run-hook build

ENV APACHE_DOCUMENT_ROOT /var/www
WORKDIR $APACHE_DOCUMENT_ROOT

EXPOSE 80
EXPOSE 443

USER $USER

ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]
