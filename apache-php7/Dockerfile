FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=
#ENV LOCAL_GID=

# Flag to install specific programs out of image.
ENV SETUP_COMPOSER=0 \
    SETUP_DRUSH=0 \
    SETUP_CONSOLE=0

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php7 php7-common php7-fpm php7-cgi \
    php7-json php7-zlib php7-phar php7-openssl php7-sockets \
    php7-pdo php7-pdo_mysql php7-mysqlnd php7-mysqli \
    php7-pdo_pgsql php7-pgsql php7-sqlite3 \
    php7-iconv php7-mcrypt php7-intl php7-mbstring php7-pcntl \
    php7-ctype  php7-bcmath php7-dom php7-xsl php7-xml php7-xmlrpc php7-xmlreader \
    php7-soap php7-ldap php7-opcache php7-xdebug php7-apcu php7-phpdbg \
    php7-posix php7-session php7-curl php7-gd php7-exif \
    php7-zip php7-bz2 php7-sysvmsg php7-sysvsem php7-sysvshm \
    php7-ftp php7-gmp php7-imap php7-calendar \
    php7-tidy php7-wddx php7-enchant php7-embed php7-litespeed php7-pear \
    php7-apache2 apache2 apache2-ssl apache2-utils \
    apache2-ldap apache2-proxy \
    mysql-client postgresql-client \
    rsync openssh openssl

# Not available on stable repo, we use a third party repo.
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN echo "http://php.codecasts.rocks/7.0" >> /etc/apk/repositories
RUN apk add --update \
    php7-memcached php7-libsodium php7-redis

# Fix Php links.
RUN ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /etc/php7 /etc/php && \
    ln -s /usr/lib/php7 /usr/lib/php

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

# Clean.
RUN rm -rf /var/cache/apk/*

# Set Apache and Php config.
COPY config/httpd.conf /etc/apache2/httpd.conf
COPY config/vhost.conf /etc/apache2/vhost/vhost.conf
COPY config/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf
COPY config/conf.d/ssl.conf /etc/apache2/conf.d/ssl.conf
COPY config/php.ini /etc/php/php.ini

# Set up drush aliases.
RUN mkdir -p /etc/drush
COPY config/aliases.drushrc.php /etc/drush/aliases.drushrc.php

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", "/var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
