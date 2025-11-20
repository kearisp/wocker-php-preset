ARG IMAGE_VERSION="8.4-apache"
FROM php:${IMAGE_VERSION}

ARG UID=1000
ARG USER=www-data

ARG PHP_EXTENSIONS=""
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
ARG IMAGICK_ENABLE=false
ARG COMPOSER_ENABLE=false
ARG NODE_VERSION=''
ARG NODE_PACKAGE_MANAGER='npm'

ENV TZ="Etc/UTC" \
    USER=$USER \
    PHP_EXTENSIONS=$PHP_EXTENSIONS \
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
    GETTEXT_ENABLE="$GETTEXT_ENABLE" \
    BCMATH_ENABLE="$BCMATH_ENABLE" \
    SOCKETS_ENABLE="$SOCKETS_ENABLE" \
    IMAGICK_ENABLE="$IMAGICK_ENABLE" \
    COMPOSER_ENABLE="$COMPOSER_ENABLE" \
    NVM_DIR="/home/$USER/.nvm" \
    NODE_VERSION="$NODE_VERSION" \
    NODE_PACKAGE_MANAGER="$NODE_PACKAGE_MANAGER" \
    PATH="${NODE_VERSION:+/home/$USER/.nvm/versions/node/$NODE_VERSION/bin:}$PATH"

ADD ./.wocker/bin/docker-entrypoint /usr/local/bin/docker-entrypoint
ADD ./.wocker/bin/compare-version /usr/local/bin/compare-version
ADD ./.wocker/bin/ws-run-hook /usr/local/bin/ws-run-hook
ADD ./.wocker/etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./.wocker/etc/apache2/apache2.conf /etc/apache2/apache2.conf
COPY ./.wocker/etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-available/
COPY ./.wocker/etc/wocker /etc/wocker

RUN mkdir -p /home/$USER && \
    usermod -d /home/$USER -u $UID -s /bin/sh $USER && \
    touch /home/$USER/.bashrc && \
    touch /home/$USER/.profile && \
    chmod 775 /usr/local/bin/docker-entrypoint && \
    chmod +x /usr/local/bin/docker-entrypoint && \
    chmod 775 /usr/local/bin/compare-version && \
    chmod +x /usr/local/bin/compare-version && \
    chmod 775 /usr/local/bin/ws-run-hook && \
    chmod +x /usr/local/bin/ws-run-hook && \
    ws-run-hook build && \
    chown -R $USER:$USER /home/$USER

ENV APACHE_DOCUMENT_ROOT /var/www
WORKDIR $APACHE_DOCUMENT_ROOT

EXPOSE 80 443

USER $USER

ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]
