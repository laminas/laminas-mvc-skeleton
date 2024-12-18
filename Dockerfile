ARG PHP_VERSION=8.3
ARG COMPOSER_VERSION="latest"

# Use a Composer image to install dependencies
# Composer should not be installed in the final image
FROM composer:${COMPOSER_VERSION} AS composer

# ---------- Base image ----------
FROM php:${PHP_VERSION}-apache AS base

WORKDIR /var/www

COPY --link --from=composer /usr/bin/composer /usr/bin/composer

## Utility to install PHP extensions
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

## Update package information
RUN apt-get update && apt-get upgrade -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    install-php-extensions \
        apcu \
        intl \
        opcache \
        zip \
        ## Add here all extensions you need
        # memcached \
        # mongodb \
        # redis \
        # mbstring \
        # pdo_mysql \
        # pdo_pgsql \
    ;

RUN a2enmod rewrite \
    && sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && mv /var/www/html /var/www/public

COPY --chown=www-data:www-data . .

## --- Development image ---
FROM base AS dev

VOLUME /var/www

WORKDIR /var/www

ENV APP_ENV=development

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN install-php-extensions xdebug \
    && composer install --no-cache --prefer-dist --no-scripts --no-progress --no-plugins --no-interaction \
    && composer dump-autoload --optimize --classmap-authoritative

## ---------- Production image ----------
FROM base AS prod

LABEL maintainer="getlaminas.org" \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.name="Laminas MVC Skeleton" \
    org.label-schema.url="https://docs.getlaminas.org/mvc/" \
    org.label-schema.vcs-url="https://github.com/laminas/laminas-mvc-skeleton"

WORKDIR /var/www

ENV APP_ENV=production

RUN composer install --no-cache --prefer-dist --no-dev --no-scripts --no-progress --no-plugins --no-interaction \
    && composer dump-autoload --optimize --apcu

#Clean up
RUN apt-get clean \
    && rm -rf /root/.composer \
    && rm -rf /usr/local/bin/install-php-extensions \
    && rm -rf /usr/local/bin/docker-php-ext-* \
    && rm -rf /usr/src/php.tar.xz \
    && rm -rf /usr/bin/phpize \
    && rm -rf /usr/bin/php-config

USER www-data
