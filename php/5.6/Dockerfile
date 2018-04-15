FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1000
#ENV LOCAL_GID=1000

# See https://hub.docker.com/_/composer/
ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.6.3
ENV COMPOSER_INSTALLER_URL "https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer"
ENV COMPOSER_INSTALLER_HASH "544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061"

# Install Php extensions, Alpine package list to update:
# https://pkgs.alpinelinux.org/packages?name=php5*&branch=v3.7&arch=x86_64
RUN apk add --update --no-cache \
    php5 \
    php5-mssql \
    php5-opcache \
    php5-pdo_dblib \
    php5-wddx \
    php5-zlib \
    php5-pdo_sqlite \
    php5-pgsql \
    php5-phar \
    php5-posix \
    php5-pspell \
    php5-shmop \
    php5-snmp \
    php5-soap \
    php5-sockets \
    php5-sqlite3 \
    php5-sysvmsg \
    php5-sysvsem \
    php5-sysvshm \
    php5-xml \
    php5-xmlreader \
    php5-xmlrpc \
    php5-xsl \
    php5-zip \
    php5-gd \
    php5-gettext \
    php5-gmp \
    php5-iconv \
    php5-imap \
    php5-intl \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-mysql \
    php5-mysqli \
    php5-odbc \
    php5-openssl \
    php5-pcntl \
    php5-pdo \
    php5-pdo_mysql \
    php5-pdo_odbc \
    php5-pdo_pgsql \
    php5-apache2 \
    php5-bcmath \
    php5-bz2 \
    php5-calendar \
    php5-cgi \
    php5-cli \
    php5-ctype \
    php5-curl \
    php5-dba \
    php5-dom \
    php5-embed \
    php5-enchant \
    php5-exif \
    php5-fpm \
    php5-ftp \
    php5-pear \
    php5-phpdbg \
    php5-common \
    php5-dbg \
    php5-dev \
    php5-doc \
    php5-apcu

# Database clients and sync needed for Drush.
RUN apk add --update --no-cache \
    mysql-client \
    postgresql-client \
    rsync \
    openssh \
    openssl \
    libmemcached-libs

# Fix php bin link.
RUN ln -s /usr/bin/php5 /usr/bin/php && \
    ln -s /usr/bin/php-fpm5 /usr/sbin/php-fpm

# dependencies required for running "phpize"
# these get automatically installed and removed by "docker-php-ext-*" (unless they're already installed)
ENV PHPIZE_DEPS \
    autoconf \
    pcre-dev \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    libmemcached-dev \
    make \
    pkgconf \
    re2c \
    zlib-dev

# Install some extensions on last php5 support version and fix pecl script.
RUN set -xe \
    && apk add --no-cache \
    --virtual .phpize-deps \
    $PHPIZE_DEPS \
    && sed -i "$ s|\-n||g" $(which pecl) \
    && pecl channel-update pecl.php.net \
    # Php 5 support dropped on > 2.5.5
    && pecl install xdebug-2.5.5 \
    # Php 5 support dropped on > 2.2.0
    && echo no | pecl install memcached-2.2.0 \
    # Php 5 support dropped on > 4
    # && printf "\n" | pecl install apcu-4.0.11 \
    && printf "\n" | pecl install redis \
    && rm -rf /tmp/* \
    && apk del .phpize-deps

# Install Composer.
# from https://github.com/composer/docker/blob/master/1.5/Dockerfile
RUN curl -s -f -L -o /tmp/installer.php ${COMPOSER_INSTALLER_URL} \
    && php -r " \
      \$signature = '${COMPOSER_INSTALLER_HASH}'; \
      \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
      if (!hash_equals(\$signature, \$hash)) { \
          unlink('/tmp/installer.php'); \
          echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
          exit(1); \
      }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && composer --ansi --version --no-interaction \
    && rm -rf /tmp/* /tmp/.htaccess

# Install prestissimo and php code sniffer with Drupal standards.
RUN /usr/bin/composer global require "hirak/prestissimo:^0.3"
RUN /usr/bin/composer global require "drupal/coder"
RUN /composer/vendor/bin/phpcs --config-set installed_paths /composer/vendor/drupal/coder/coder_sniffer

# Fix composer cache folder permission to run composer as apache user.
RUN chown -R apache:www-data /composer/cache

# Copy root bashrc config for Apache user when running cmd.
RUN cp /root/.bashrc /var/www/.bashrc && \
    chown -R apache:www-data /var/www

# Clean.
RUN rm -rf /var/cache/apk/*

# Set apache script.
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 9000

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
