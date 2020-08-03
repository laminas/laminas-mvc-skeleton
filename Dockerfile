FROM php:7.4-apache

LABEL maintainer="getlaminas.org" \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.name="Laminas MVC Skeleton" \
    org.label-schema.url="https://docs.getlaminas.org/mvc/" \
    org.label-schema.vcs-url="https://github.com/laminas/laminas-mvc-skeleton"

## Update package information
RUN apt-get update

## Configure Apache
RUN a2enmod rewrite
RUN sed -i 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf
RUN mv /var/www/html /var/www/public

## Install Composer
RUN curl -sS https://getcomposer.org/installer \
  | php -- --install-dir=/usr/local/bin --filename=composer

###
## PHP Extensisons
###

## Install zip libraries and extension
RUN apt-get install --yes git zlib1g-dev libzip-dev
RUN docker-php-ext-install zip

## Install intl library and extension
RUN apt-get install --yes libicu-dev
RUN docker-php-ext-configure intl 
RUN docker-php-ext-install intl

###
## Optional PHP extensions 
###

## mbstring for i18n string support
# RUN docker-php-ext-install mbstring

###
## Some laminas/laminas-db supported PDO extensions
###

## MySQL PDO support
# RUN docker-php-ext-install pdo_mysql

## PostgreSQL PDO support
# RUN apt-get install --yes libpq-dev
# RUN docker-php-ext-install pdo_pgsql

###
## laminas/laminas-cache supported extensions
###

## APCU
# RUN pecl install apcu
# RUN docker-php-ext-enable apcu

## Memcached
# RUN apt-get install --yes libmemcached-dev 
# RUN pecl install memcached
# RUN docker-php-ext-enable memcached

## MongoDB
# RUN pecl install mongodb
# RUN docker-php-ext-enable mongodb

## Redis support.  igbinary and libzstd-dev are only needed based on 
## redis pecl options
# RUN pecl install igbinary
# RUN docker-php-ext-enable igbinary
# RUN apt-get install --yes libzstd-dev
# RUN pecl install redis
# RUN docker-php-ext-enable redis


WORKDIR /var/www
