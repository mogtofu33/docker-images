FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID= \
#    LOCAL_GID=

# Flag to install specific programs.
ENV SETUP_COMPOSER=false
ENV SETUP_DRUSH=true
ENV SETUP_CONSOLE=true

# Install Php extensions, Drush need mysql/postgresql-client and rsync.
RUN apk add --update \
    php5-cli php5-fpm \
    php5-json php5-zlib php5-xml php5-phar php5-openssl php5-sockets \
    php5-pdo php5-pdo_mysql php5-mysql php5-mysqli \
    php5-pdo_pgsql php5-pgsql \
    php5-gd php5-iconv php5-mcrypt \
    php5-curl php5-ctype php5-intl php5-bcmath \
    php5-dom php5-xmlreader php5-ldap \
    php5-memcached php5-opcache php5-apcu \
    php5-xdebug php5-redis php5-posix \
    apache2 php5-apache2 apache2-ssl \
    mysql-client postgresql-client \
    rsync openssh openssl

# Create specific Php-Fpm user.
RUN useradd phpfpm && \
    groupadd phpfpm && \
    usermod -g phpfpm phpfpm && \
    usermod -G phpfpm phpfpm

# Fix Php links.
RUN ln -s /etc/php5 /etc/php && \
    rm -rf /usr/lib/php && \
    ln -s /usr/lib/php5 /usr/lib/php

# Prepare php logs.
RUN mkdir -p /var/log/php && \
    touch /var/log/php/phpfpm.error.log && \
    touch /var/log/php/phpfpm.access.log && \
    chown -R phpfpm:phpfpm /var/log/php

# Clean.
RUN rm -f /var/cache/apk/*

# Config and run script.
COPY config/php.ini /etc/php5/php.ini
COPY config/php-fpm.conf /etc/php5/php-fpm.conf
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 9000

VOLUME ["/var/log/php"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
