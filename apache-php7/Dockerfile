FROM mogtofu33/docker-alpine-edge-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1001 \
#    LOCAL_GID=1001

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php7 php7-fpm \
    php7-json php7-zlib php7-xml php7-phar php7-openssl php7-sockets \
    php7-pdo php7-pdo_mysql php7-mysqlnd php7-mysqli \
    php7-pdo_pgsql php7-pgsql \
    php7-iconv php7-mcrypt \
    php7-curl php7-ctype  php7-bcmath \
    php7-dom php7-xmlreader php7-ldap \
    php7-memcached php7-opcache php7-xdebug \
    php7-redis php7-posix php7-session \
    php7-intl php7-gd php7-mbstring \
    php7-apache2 apache2 \
    mysql-client postgresql-client \
    rsync openssh

# Fix Php links.
RUN ln -s /usr/bin/php7 /usr/bin/php
RUN ln -s /etc/php7 /etc/php
RUN ln -s /usr/lib/php7 /usr/lib/php

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
    mkdir -p /etc/apache2/vhost && \
    chown -R apache:www-data /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:www-data /run/apache2

# Setup drush aliases.
RUN mkdir -p /www/drush/ /etc/drush/
COPY config/aliases.drushrc.php /www/drush/aliases.drushrc.php
RUN ln -s /www/drush/aliases.drushrc.php /etc/drush/aliases.drushrc.php

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2  && \
    chown -R apache:www-data /var/log/apache2

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
