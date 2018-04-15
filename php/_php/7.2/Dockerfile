FROM php:7-fpm-alpine3.7

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

RUN docker-php-source extract \
    && apk add --no-cache --virtual .phpize-deps-configure $PHPIZE_DEPS \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        imagemagick-dev \
        libtool \
        libintl \
        icu \
        icu-dev \
        libxml2-dev \
        pcre-dev \
        postgresql-dev \
        libmemcached-dev \
        zlib-dev \
        bzip2-dev \
        gmp \
        gmp-dev

RUN pecl install xdebug \
    && pecl install redis \
    && pecl install apcu \
    && pecl install imagick \
    && pecl install memcached \
    && pecl install mcrypt-1.0.1

RUN docker-php-ext-enable xdebug redis apcu imagick memcached mcrypt

RUN docker-php-ext-install mysqli pdo_mysql pdo_pgsql gmp bcmath intl zip soap

# RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#     && docker-php-ext-install -j"$(getconf _NPROCESSORS_ONLN)" gdexit

RUN docker-php-ext-install \
    # bz2 \
    calendar dba enchant exif \
    gettext imap interbase intl ldap \
    oci8 odbc opcache pcntl pdo_dblib pgsql pspell \
    recode shmop snmp soap sockets \
    sysvmsg sysvsem sysvshm tidy wddx \
    xmlrpc xsl

RUN echo "$(php -m)"

# RUN apk del .phpize-deps-configure \
    # && docker-php-source delete

# Set apache script.
# COPY scripts/run.sh /scripts/run.sh
# RUN chmod +x /scripts/run.sh

EXPOSE 9000

# VOLUME ["/var/www/localhost"]

# ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]

# RUN sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf

# RUN echo "expose_php=0" > /usr/local/etc/php/php.ini

CMD ["php-fpm", "-F"]
