FROM php:7.0-apache

MAINTAINER moimog33@gmail.com

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install redis-3.1.2 \
    && pecl install xdebug-2.5.4 \
    && docker-php-ext-enable redis xdebug

RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached-3.0.3 \
    && docker-php-ext-enable memcached

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    chown -R apache:www-data /www && \
    mkdir -p /etc/apache2/vhost && \
    chown -R apache:www-data /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:www-data /run/apache2

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    touch /var/log/apache2/php-error.log && \
    chown -R apache:www-data /var/log/apache2

# Set Apache and Php config.
# COPY config/httpd.conf /etc/apache2/httpd.conf
# COPY config/vhost.conf /etc/apache2/vhost/vhost.conf
# COPY config/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf
# COPY config/conf.d/ssl.conf /etc/apache2/conf.d/ssl.conf
# COPY config/php.ini /etc/php/php.ini
COPY config/php.ini /usr/local/etc/php/

# Set up drush aliases.
RUN mkdir -p /etc/drush
COPY config/aliases.drushrc.php /etc/drush/aliases.drushrc.php

# Set apache script
# COPY scripts/run.sh /scripts/run.sh
# RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", "/var/log/apache2"]

# ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
