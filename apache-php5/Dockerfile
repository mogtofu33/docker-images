FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=
#ENV LOCAL_GID=

ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.4.2
ENV SETUP_COMPOSER=0

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php5-cli php5-fpm \
    php5-json php5-zlib php5-xml php5-phar php5-openssl php5-sockets \
    php5-pdo php5-pdo_mysql php5-mysql php5-mysqli \
    php5-pdo_pgsql php5-pgsql \
    php5-gd php5-iconv php5-mcrypt \
    php5-curl php5-ctype php5-intl php5-bcmath \
    php5-dom php5-xmlreader php5-ldap php5-opcache  \
     php5-posix php5-exif \
    php5-apache2 apache2 apache2-ssl apache2-utils \
    apache2-ldap apache2-proxy \
    mysql-client postgresql-client \
    rsync openssh openssl

# These extensions are no more available or Alpine.
# php5-apcu php5-memcached php5-xdebug php5-redis
# Fix xdebug warning.
#RUN sed -i "s/extension=xdebug.so/zend_extension=xdebug.so/" /etc/php/conf.d/xdebug.ini

# Install Composer.
RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
    && php -r " \
      \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
      \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
      if (!hash_equals(\$signature, \$hash)) { \
          unlink('/tmp/installer.php'); \
          echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
          exit(1); \
      }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm /tmp/installer.php \
    && composer --ansi --version --no-interaction

# Prepare Web root and Apache.
RUN chown -R apache:www-data /var/www && \
    mkdir -p /www && \
    chown -R apache:www-data /www && \
    mkdir /etc/apache2/vhost && \
    chown -R apache:www-data /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:www-data /run/apache2

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    touch /var/log/apache2/php-error.log && \
    chown -R apache:www-data /var/log/apache2

# Clean.
RUN rm -rf /var/cache/apk/*

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", "/var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
