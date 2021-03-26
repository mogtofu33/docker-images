FROM mogtofu33/alpine-base:3.13

LABEL maintainer="dev-drupal.com"

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

# Install Php extensions,Alpine package list to:
#   https://pkgs.alpinelinux.org/packages?name=php7*&branch=v3.13&arch=x86_64
RUN apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    # Patch for composer patch plugin, the one included in busybox does not support the '-f' parameter and fails
    patch \
    # Database clients and sync needed for Drush.
    mysql-client \
    postgresql-client \
    # Php and third party.
    redis \
    imagemagick \
    php7 \
    php7-apache2 \
    php7-bcmath \
    php7-bz2 \
    php7-calendar \
    php7-cgi \
    php7-common \
    php7-ctype \
    php7-curl \
    php7-dba \
    php7-dev \
    php7-dom \
    php7-embed \
    php7-enchant \
    php7-exif \
    php7-fileinfo \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-gettext \
    php7-gmp \
    php7-iconv \
    php7-imap \
    php7-intl \
    php7-json \
    php7-ldap \
    php7-litespeed \
    php7-mailparse \
    php7-mbstring \
    php7-mysqli \
    php7-mysqlnd \
    php7-oauth \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pear \
    php7-pgsql \
    php7-phar \
    php7-phpdbg \
    php7-posix \
    php7-pspell \
    php7-session \
    php7-shmop \
    php7-simplexml \
    php7-snmp \
    php7-soap \
    php7-sockets \
    php7-sodium \
    php7-sqlite3 \
    php7-tidy \
    php7-tokenizer \
    php7-xml \
    php7-xmlreader \
    php7-xmlrpc \
    php7-xmlwriter \
    php7-xsl \
    php7-zip \
    php7-zmq \
    php7-pecl-apcu \
    php7-pecl-ast \
    php7-pecl-event \
    php7-pecl-imagick \
    php7-pecl-lzf \
    php7-pecl-mcrypt \
    php7-pecl-memcached \
    php7-pecl-redis \
    php7-pecl-timezonedb \
    php7-pecl-xdebug \
    php7-pecl-yaml

# Install composer.
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy Php fpm start script.
COPY ./scripts/run.sh /scripts/run.sh

# Fix composer cache folder permission to run composer as apache user.
RUN chmod +x /usr/bin/composer && \
    chmod +x /scripts/run.sh && \
    chown -R apache:www-data /var/www && \
    # Copy root bashrc config for Apache user when running cmd.
    cp /root/.bashrc /var/www/.bashrc

# Install prestissimo and php code sniffer with Drupal standards.
USER apache
RUN /usr/bin/composer global require "drupal/coder" && \
    ~/.composer/vendor/bin/phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer

USER root

# Clean.
RUN rm -rf /var/www/.composer/cache/*

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
