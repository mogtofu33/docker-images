FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID= \
#    LOCAL_GID=

# Flag to install specific programs.
ENV SETUP_COMPOSER=0
ENV SETUP_DRUSH=1
ENV SETUP_CONSOLE=1

# Install Php extensions, Apache and database client/rsync for Drush.
# php7-memcached currently only for arm, waiting https://pkgs.alpinelinux.org/packages?name=php7-memcached
RUN apk add --update \
    php7 php7-fpm \
    php7-json php7-zlib php7-xml php7-phar php7-openssl php7-sockets \
    php7-pdo php7-pdo_mysql php7-mysqlnd php7-mysqli \
    php7-pdo_pgsql php7-pgsql \
    php7-iconv php7-mcrypt \
    php7-curl php7-ctype  php7-bcmath \
    php7-dom php7-xmlreader php7-ldap \
    php7-opcache php7-xdebug \
    php7-redis php7-posix php7-session \
    php7-intl php7-gd php7-mbstring \
    php7-apache2 apache2 apache2-ssl \
    mysql-client postgresql-client \
    rsync openssh openssl

# Fix Php links.
RUN ln -s /usr/bin/php7 /usr/bin/php
RUN ln -s /etc/php7 /etc/php
RUN ln -s /usr/lib/php7 /usr/lib/php

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    chown -R apache:www-data /www && \
    mkdir -p /etc/apache2/vhost && \
    chown -R apache:www-data /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:www-data /run/apache2

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    mkdir -p /var/log/php7 && \
    chown -R apache:www-data /var/log/apache2 && \
    chown -R apache:www-data /var/log/php7

# Clean.
RUN rm -rf /var/cache/apk/*

# Set Apache and Php config.
COPY config/httpd.conf /etc/apache2/httpd.conf
COPY config/vhost.conf /etc/apache2/vhost/vhost.conf
COPY config/php.ini /etc/php/php.ini

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80

VOLUME ["/www", "/etc/apache2/vhost", /var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
