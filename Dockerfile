FROM php:7.2-apache

# Packages
RUN apt-get update && \
    apt-get install -y \
    git \
    less \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmagickwand-dev --no-install-recommends \
    libpng-dev \
    libtidy-dev \
    locales --no-install-recommends \
    openssh-client \
    rsync \
    ssh \
    unzip

# PHP extensions configure
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr

# PHP extensions install
RUN docker-php-ext-install \
    bcmath \
    exif \
    gd \
    intl \
    ldap \
    mysqli \
    opcache \
    soap \
    sockets \
    tidy \
    zip

# PHP pecl extensions install
RUN pecl install \
    imagick \
    xdebug

# PHP extensions enable
RUN docker-php-ext-enable \
    imagick \
    xdebug

# Set env
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen de_DE.UTF-8 && \
    update-locale LANG=de_DE.UTF-8 LC_CTYPE=de_DE.UTF-8 && \
    dpkg-reconfigure locales -f noninteractive -p critical && \
    locale -a

# Apache mod
RUN a2enmod \
    headers \
    rewrite \
    ssl