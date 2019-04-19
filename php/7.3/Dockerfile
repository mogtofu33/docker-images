FROM mogtofu33/alpine-base:3.9

LABEL maintainer="dev-drupal.com"

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

# We use a third party repo to get last 7.3 version.
# https://github.com/codecasts/php-alpine#dockerfile
# https://pkgs.alpinelinux.org/packages?name=php7*&branch=v3.9&arch=x86_64
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "@php https://php.codecasts.rocks/v3.9/php-7.3" >> /etc/apk/repositories && \
    apk add --update --no-cache \
    # Database clients and sync needed for Drush.
    mysql-client \
    postgresql-client \
    # Php and third party.
    imagemagick \
    php@php \
    php-common@php \
    php-sysvsem@php \
    php-sysvshm@php \
    php-tidy@php \
    php-wddx@php \
    php-xml@php \
    php-xmlreader@php \
    php-xmlrpc@php \
    php-xsl@php \
    php-zip@php \
    php-phar@php \
    php-posix@php \
    php-pspell@php \
    php-session@php \
    php-shmop@php \
    php-snmp@php \
    php-soap@php \
    php-sockets@php \
    php-sqlite3@php \
    php-sysvmsg@php \
    php-mysqlnd@php \
    php-odbc@php \
    php-opcache@php \
    php-openssl@php \
    php-pcntl@php \
    php-pdo@php \
    php-pdo_dblib@php \
    php-pdo_mysql@php \
    php-pdo_pgsql@php \
    php-pdo_sqlite@php \
    php-pgsql@php \
    php-gettext@php \
    php-gmp@php \
    php-iconv@php \
    php-imap@php \
    php-intl@php \
    php-json@php \
    php-ldap@php \
    php-mbstring@php \
    php-mysqli@php \
    php-bcmath@php \
    php-bz2@php \
    php-calendar@php \
    php-ctype@php \
    php-curl@php \
    php-dba@php \
    php-dom@php \
    php-embed@php \
    php-enchant@php \
    php-exif@php \
    php-ftp@php \
    php-gd@php \
    php-pear@php \
    php-apache2@php \
    php-cgi@php \
    php-dev@php \
    php-doc@php \
    php-fpm@php \
    php-litespeed@php \
    php-phpdbg@php \
    php-amqp@php \
    php-apcu@php \
    php-memcached@php \
    php-imagick@php \
    php-psr@php \
    php-xdebug@php \
    php-redis@php \
    php-zlib@php \
    php-sodium@php \
    php-mcrypt@php

# Install composer.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Php fpm start script.
COPY ./scripts/run.sh /scripts/run.sh

# Install prestissimo and php code sniffer with Drupal standards.
RUN /usr/bin/composer global require "hirak/prestissimo:^0.3" "drupal/coder" \
    && /composer/vendor/bin/phpcs --config-set installed_paths /composer/vendor/drupal/coder/coder_sniffer \
    # Fix composer cache folder permission to run composer as apache user.
    && chmod +x /usr/bin/composer \
    && chmod +x /scripts/run.sh \
    # Copy root bashrc config for Apache user when running cmd.
    && cp /root/.bashrc /var/www/.bashrc \
    && chown apache:www-data /usr/bin/composer \
    && chown -R apache:www-data /composer/cache /var/www \
    # Clean.
    && rm -rf ~/.composer/cache/* \
    && rm -rf /var/cache/apk/*

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
