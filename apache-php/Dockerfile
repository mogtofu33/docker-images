FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=
#ENV LOCAL_GID=

# Flag to install specific programs.
ENV SETUP_COMPOSER=1
ENV SETUP_DRUSH=1
ENV SETUP_CONSOLE=1

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php5-cli php5-fpm \
    php5-json php5-zlib php5-xml php5-phar php5-openssl php5-sockets \
    php5-pdo php5-pdo_mysql php5-mysql php5-mysqli \
    php5-pdo_pgsql php5-pgsql \
    php5-gd php5-iconv php5-mcrypt \
    php5-curl php5-ctype php5-intl php5-bcmath \
    php5-dom php5-xmlreader php5-ldap \
    php5-memcached php5-opcache php5-apcu \
    php5-xdebug php5-redis php5-posix php5-exif \
    apache2 php5-apache2 apache2-proxy apache2-ssl apache2-ldap \
    mysql-client postgresql-client \
    rsync openssh openssl

# Fix xdebug warning.
#RUN sed -i "s/extension=xdebug.so/zend_extension=xdebug.so/" /etc/php/conf.d/xdebug.ini

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    chown -R apache:www-data /www && \
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
COPY config/vhost.conf /etc/apache2/vhost/vhost.conf
COPY config/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf
COPY config/php.ini /etc/php/php.ini

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", /var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
