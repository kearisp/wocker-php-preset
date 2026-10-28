ARG IMAGE_VERSION="8.4-apache"
FROM php:${IMAGE_VERSION}

LABEL wocker.name="php" \
      wocker.type="preset" \
      wocker.version="2.0.0" \
      wocker.description="Wocker preset for php projects"

ARG UID=1000
ARG USER=www-data

ARG PHP_EXTENSIONS=""
ARG XDEBUG_MODE="off"
ARG COMPOSER_ENABLE=false
ARG SLIM_IMAGE=false
ARG NODE_VERSION=''
ARG NODE_PACKAGE_MANAGER='npm'

ENV TZ="Etc/UTC" \
    USER=$USER \
    PHP_EXTENSIONS=$PHP_EXTENSIONS \
    XDEBUG_MODE="$XDEBUG_MODE" \
    COMPOSER_ENABLE="$COMPOSER_ENABLE" \
    SLIM_IMAGE="$SLIM_IMAGE" \
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

RUN chmod 775 /usr/local/bin/docker-entrypoint && \
    chmod +x /usr/local/bin/docker-entrypoint && \
    chmod 775 /usr/local/bin/compare-version && \
    chmod +x /usr/local/bin/compare-version && \
    chmod 775 /usr/local/bin/ws-run-hook && \
    chmod +x /usr/local/bin/ws-run-hook && \
    ws-run-hook build

ENV APACHE_DOCUMENT_ROOT /var/www
WORKDIR $APACHE_DOCUMENT_ROOT

EXPOSE 80 443

USER $USER

ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]
