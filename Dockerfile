FROM php:7.2
RUN  apt-get update && apt-get install -y libldap2-dev \
     libfreetype6-dev \
     libjpeg62-turbo-dev \
     libpng-dev \
     git \
     rsync \
     ssh \
     less \
     unzip \
     openssh-client \
     libicu-dev \
     libtidy-dev libtidy5 \
     libmagickwand-dev --no-install-recommends \
     && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
     && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
     && rm -rf /var/lib/apt/lists/* \
     && docker-php-ext-install -j$(nproc) exif ldap bcmath zip intl tidy soap sockets \
     && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
     && docker-php-ext-install -j$(nproc) gd \
     && pecl install imagick-3.4.3 \
     && docker-php-ext-enable imagick

RUN  curl -sL https://deb.nodesource.com/setup_11.x | bash - \
     && apt-get install -y nodejs \
     && npm install -g grunt-cli

RUN  curl --silent --show-error -LO https://getcomposer.org/installer \
     && php installer --install-dir=/usr/local/bin --filename=composer \
     && chmod 755 /usr/local/bin/composer

RUN  apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales

ENV  LANG de_DE.UTF-8
ENV  LANGUAGE de_DE:de
ENV  LC_ALL de_DE.UTF-8
RUN  echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen && \
     locale-gen de_DE.UTF-8 && \
     update-locale LANG=de_DE.UTF-8 LC_CTYPE=de_DE.UTF-8 && \
     dpkg-reconfigure locales -f noninteractive -p critical && \
     locale -a

RUN  pecl install xdebug && \
     docker-php-ext-enable xdebug
