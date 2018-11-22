FROM mogtofu33/alpine-base:3.7

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

# We use a third party repo to get last 7.1 version.
# https://github.com/codecasts/php-alpine#dockerfile
# https://pkgs.alpinelinux.org/packages?name=php7*&branch=v3.7&arch=x86_64
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "@php https://php.codecasts.rocks/v3.7/php-7.1" >> /etc/apk/repositories && \
    apk add --update --no-cache \
    # Database clients and sync needed for Drush.
    mysql-client \
    postgresql-client \
    # Php and third party.
    imagemagick \
    php7@php \
    php7-common@php \
    php7-sysvsem@php \
    php7-sysvshm@php \
    php7-tidy@php \
    php7-wddx@php \
    php7-xml@php \
    php7-xmlreader@php \
    php7-xmlrpc@php \
    php7-xsl@php \
    php7-zip@php \
    php7-phar@php \
    php7-posix@php \
    php7-pspell@php \
    php7-session@php \
    php7-shmop@php \
    php7-snmp@php \
    php7-soap@php \
    php7-sockets@php \
    php7-sqlite3@php \
    php7-sysvmsg@php \
    php7-mysqlnd@php \
    php7-odbc@php \
    php7-opcache@php \
    php7-openssl@php \
    php7-pcntl@php \
    php7-pdo@php \
    php7-pdo_dblib@php \
    php7-pdo_mysql@php \
    php7-pdo_pgsql@php \
    php7-pdo_sqlite@php \
    php7-pgsql@php \
    php7-gettext@php \
    php7-gmp@php \
    php7-iconv@php \
    php7-imap@php \
    php7-intl@php \
    php7-json@php \
    php7-ldap@php \
    php7-mbstring@php \
    php7-mcrypt@php \
    php7-mysqli@php \
    php7-bcmath@php \
    php7-bz2@php \
    php7-calendar@php \
    php7-ctype@php \
    php7-curl@php \
    php7-dba@php \
    php7-dom@php \
    php7-embed@php \
    php7-enchant@php \
    php7-exif@php \
    php7-ftp@php \
    php7-gd@php \
    php7-pear@php \
    php7-apache2@php \
    php7-cgi@php \
    php7-dev@php \
    php7-doc@php \
    php7-fpm@php \
    php7-litespeed@php \
    php7-phpdbg@php \
    php7-amqp@php \
    php7-mailparse@php \
    php7-apcu@php \
    php7-memcached@php \
    php7-imagick@php \
    php7-ssh2@php \
    php7-xdebug@php \
    php7-redis@php \
    php7-zlib@php \
    php7-libsodium@php \
    php7-fileinfo \
    php7-oauth \
    php7-zmq

# Install composer.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Php fpm start script.
COPY ./scripts/run.sh /scripts/run.sh

RUN ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
    && ln -s /usr/bin/php7 /usr/bin/php \
    # Symlink for cache.
    && ln -s /root/.composer/ /composer \
    && ln -s /root/.composer/ /.composer \
    # Install prestissimo and php code sniffer with Drupal standards.
    && /usr/bin/composer global require "hirak/prestissimo:^0.3" "drupal/coder" \
    && /composer/vendor/bin/phpcs --config-set installed_paths /composer/vendor/drupal/coder/coder_sniffer \
    # Fix composer cache folder permission to run composer as apache user.
    && chmod +x /usr/bin/composer \
    && chmod +x /scripts/run.sh \
    # Copy root bashrc config for Apache user when running cmd.
    && cp /root/.bashrc /var/www/.bashrc \
    && chown apache:www-data /usr/bin/composer \
    && chown -R apache:www-data /composer/cache /var/www \
    # Clean.
    && rm -rf /var/cache/apk/*

# Phpfpm port.
EXPOSE 9000

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
