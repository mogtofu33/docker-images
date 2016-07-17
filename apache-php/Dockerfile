FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1000 \
#    LOCAL_GID=1000

# Flag to install specific programs.
ENV SETUP_COMPOSER=true
ENV SETUP_DRUSH=true
ENV SETUP_CONSOLE=true

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php-cli php-fpm \
    php-json php-zlib php-xml php-phar php-openssl php-sockets \
    php-pdo php-pdo_mysql php-mysql php-mysqli \
    php-pdo_pgsql php-pgsql \
    php-gd php-iconv php-mcrypt \
    php-curl php-ctype php-intl php-bcmath \
    php-dom php-xmlreader php-ldap \
    php-memcached php-opcache php-apcu \
    php-xdebug php-redis php-posix \
    apache2 php-apache2 apache2-ssl \
    mysql-client postgresql-client \
    rsync openssh openssl

# Fix xdebug warning.
RUN sed -i "s/extension=xdebug.so/zend_extension=xdebug.so/" /etc/php/conf.d/xdebug.ini

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    mkdir /etc/apache2/vhost && \
    chown -R apache:apache /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:apache /run/apache2

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    mkdir -p /var/log/php && \
    chown -R apache:www-data /var/log/apache2 && \
    chown -R apache:www-data /var/log/php

# Clean.
RUN rm -rf /var/cache/apk/*

# Set Apache and Php config.
COPY config/httpd.conf /etc/apache2/httpd.conf
COPY config/php.ini /etc/php/php.ini

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80

VOLUME ["/www", "/var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
