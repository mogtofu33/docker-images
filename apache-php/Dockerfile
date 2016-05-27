FROM mogtofu33/docker-alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1001 \
#    LOCAL_GID=1001

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
    apache2 php-apache2 \
    mysql-client postgresql-client \
    rsync openssh

# Fix xdebug warning.
RUN sed -i "s/extension=xdebug.so/zend_extension=xdebug.so/" /etc/php/conf.d/xdebug.ini

# Composer last version.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "PATH=$PATH:~/.composer/vendor/bin" >> /root/.bashrc

# Drush last version.
RUN curl -sS http://files.drush.org/drush.phar -L -o drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    chmod +x /usr/local/bin/drush
RUN drush init -y >/dev/null

# Drupal console last version.
RUN curl -sS https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal
RUN drupal init >/dev/null

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    mkdir /etc/apache2/vhost && \
    chown -R apache:apache /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:apache /run/apache2

# Setup drush aliases.
RUN mkdir -p /www/drush/ /etc/drush/
COPY config/aliases.drushrc.php /www/drush/aliases.drushrc.php
RUN ln -s /www/drush/aliases.drushrc.php /etc/drush/aliases.drushrc.php

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    chown -R apache:apache /var/log/apache2

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
