FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=
#ENV LOCAL_GID=

ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.6.3
ENV COMPOSER_INSTALLER_URL "https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer"
ENV COMPOSER_INSTALLER_HASH "544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061"

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update --no-cache \
    php5-cli php5-fpm \
    php5-json php5-zlib php5-xml php5-phar php5-openssl php5-sockets \
    php5-pdo php5-pdo_mysql php5-mysql php5-mysqli \
    php5-pdo_pgsql php5-pgsql \
    php5-gd php5-iconv php5-mcrypt \
    php5-curl php5-ctype php5-intl php5-bcmath \
    php5-dom php5-xmlreader php5-ldap php5-opcache  \
    php5-posix php5-exif \
    php5-apcu php5-dev \
    php5-apache2 apache2 apache2-ssl apache2-utils \
    apache2-ldap apache2-proxy \
    mysql-client postgresql-client \
    rsync openssh openssl \
    libmemcached-libs

# These extensions are no more available or Alpine.
# php5-apcu php5-memcached php5-xdebug php5-redis
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
    && sed -i "$ s|\-n||g" /usr/bin/pecl \
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

RUN /usr/bin/composer global require "hirak/prestissimo:^0.3"
RUN /usr/bin/composer global require "drupal/coder"
RUN /composer/vendor/bin/phpcs --config-set installed_paths /composer/vendor/drupal/coder/coder_sniffer

# Fix composer cache folder permission to run composer as apache user.
RUN chown -R apache:www-data /composer/cache

# Copy root bashrc config for Apache user when running cmd.
RUN cp /root/.bashrc /var/www/.bashrc && \
    chown apache:www-data /var/www/.bashrc

# Fix web root permission, set php and apache logs.
RUN chown -R apache:www-data /var/www && \
    mkdir -p /var/log/apache2 && \
    touch /var/log/apache2/php-error.log && \
    chown -R apache:www-data /var/log/apache2

# Clean.
RUN rm -rf /var/cache/apk/*

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/var/www", "/etc/apache2/vhost", "/var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
