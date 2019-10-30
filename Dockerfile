FROM php:7.2-apache

# Packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmagickwand-dev \
    libpng-dev \
    locales \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# PHP extensions configure
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr

# PHP extensions install
RUN docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    intl \
    ldap \
    mysqli \
    opcache \
    soap \
    sockets \
    zip

# PHP pecl extensions install
RUN pecl install \
    imagick \
    xdebug

# PHP extensions enable
RUN docker-php-ext-enable \
    imagick \
    xdebug

# Set locale
RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen de_DE.UTF-8 && \
    update-locale LANG=de_DE.UTF-8 LC_CTYPE=de_DE.UTF-8

# Set env
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

# Apache mod
RUN a2enmod \
    headers \
    rewrite \
    ssl