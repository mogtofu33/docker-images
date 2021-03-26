FROM mogtofu33/alpine-base:3.13

LABEL maintainer="dev-drupal.com"

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

# Install Php extensions,Alpine package list to:
#   https://pkgs.alpinelinux.org/packages?name=php8*&branch=v3.13&arch=x86_64
RUN apk add --update --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main \
    # Patch for composer patch plugin, the one included in busybox does not support the '-f' parameter and fails
    patch \
    # Database clients and sync needed for Drush.
    mysql-client \
    postgresql-client \
    # Php and third party.
    redis \
    imagemagick \
    php8 \
    php8-apache2 \
    php8-bcmath \
    php8-bz2 \
    php8-calendar \
    php8-cgi \
    php8-common \
    php8-ctype \
    php8-curl \
    php8-dbg \
    php8-dev \
    php8-dom \
    php8-embed \
    php8-enchant \
    php8-exif \
    php8-fileinfo \
    php8-fpm \
    php8-ftp \
    php8-gd \
    php8-gettext \
    php8-gmp \
    php8-iconv \
    php8-imap \
    php8-intl \
    php8-json \
    php8-ldap \
    php8-litespeed \
    php8-mbstring \
    php8-mysqli \
    php8-mysqlnd \
    php8-opcache \
    php8-openssl \
    php8-pcntl \
    php8-pdo \
    php8-pdo_mysql \
    php8-pdo_pgsql \
    php8-pdo_sqlite \
    php8-pear \
    php8-pgsql \
    php8-phar \
    php8-phpdbg \
    php8-posix \
    php8-pspell \
    php8-session \
    php8-shmop \
    php8-simplexml \
    php8-snmp \
    php8-soap \
    php8-sockets \
    php8-sodium \
    php8-sqlite3 \
    php8-tidy \
    php8-tokenizer \
    php8-xml \
    php8-xmlreader \
    php8-xmlwriter \
    php8-xsl \
    php8-zip \
    php8-pecl-apcu \
    php8-pecl-ast \
    php8-pecl-event \
    php8-pecl-xhprof \
    php8-pecl-imagick \
    php8-pecl-lzf \
    php8-pecl-mailparse \
    php8-pecl-mcrypt \
    php8-pecl-memcached \
    php8-pecl-oauth \
    php8-pecl-redis \
    php8-pecl-timezonedb \
    php8-pecl-uploadprogress \
    php8-pecl-uuid \
    php8-pecl-xdebug \
    php8-pecl-yaml && \
    ln -s /usr/bin/php8 /usr/bin/php && \
    ln -s /usr/bin/phpize8 /usr/bin/phpize && \
    ln -s /usr/bin/phpdbg8 /usr/bin/phpdbg && \
    ln -s /usr/sbin/php-fpm8 /usr/sbin/php-fpm

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
