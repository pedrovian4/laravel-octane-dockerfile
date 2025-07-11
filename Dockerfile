ARG PHP_VERSION=8.4
ARG COMPOSER_VERSION=2.8
ARG NODE_VERSION=22
ARG WWWUSER=1000
ARG WWWGROUP=1000
ARG TZ='America/Sao_Paulo'

FROM composer:${COMPOSER_VERSION} AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --classmap-authoritative \
    --ignore-platform-reqs \
    --no-scripts

FROM node:${NODE_VERSION}-alpine AS assets
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps
COPY resources resources
COPY vite.config.ts ./
RUN npm run build

FROM php:${PHP_VERSION}-cli-alpine AS prod
LABEL maintainer="Pedro Viana"
ARG WWWUSER
ARG WWWGROUP
ARG APP_USER=laravel
ARG APP_ROOT=/var/www/html

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

WORKDIR ${APP_ROOT}


RUN apk update && apk upgrade && \
    apk add --no-cache \
      curl \
      wget \
      python3 py3-pip py3-setuptools \
      tzdata \
      ncdu \
      procps \
      unzip \
      ca-certificates \
      supervisor \
      libsodium-dev \
      brotli && \
    install-php-extensions \
      bz2 \
      pcntl \
      mbstring \
      bcmath \
      sockets \
      pgsql \
      pdo_pgsql \
      opcache \
      exif \
      pdo_mysql \
      zip \
      uv \
      vips \
      intl \
      gd \
      redis \
      memcached \
      igbinary \
      ldap \
      swoole && \
    docker-php-source delete && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone

WORKDIR ${APP_ROOT}

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY --from=vendor /app/vendor ./vendor
COPY --from=assets /app/public ./public

COPY . .
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY supervisord.conf /etc/supervisord.conf
RUN ln -s /etc/supervisord.conf /etc/supervisor.ini
COPY laravel.conf /etc/supervisor/conf.d/laravel.conf

RUN mkdir -p \
    storage/framework/sessions \
    storage/framework/views \
    storage/framework/cache \
    storage/framework/testing \
    storage/logs \
    bootstrap/cache && chmod -R a+rw storage

RUN composer install \
    --classmap-authoritative \
    --no-interaction \
    --no-ansi \
    --no-dev \
    && composer clear-cache

RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache && \
    php artisan event:cache

RUN addgroup -g ${WWWGROUP} ${APP_USER} && \
    adduser -D -h ${APP_ROOT} -G ${APP_USER} -u ${WWWUSER} -s /bin/sh ${APP_USER}

RUN chown -R ${WWWUSER}:${WWWGROUP} storage bootstrap/cache public
RUN mkdir -p /var/log/supervisor

EXPOSE 8000
ENTRYPOINT ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
