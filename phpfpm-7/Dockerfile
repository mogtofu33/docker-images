FROM mogtofu33/docker-alpine-edge-base:latest

MAINTAINER moimog33@gmail.com

# ENV LOCAL_UID=1001 \
    # LOCAL_GID=1001

# Install Php extensions, Drush need mysql/postgresql-client and rsync.
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
    mysql-client postgresql-client \
    rsync openssh

# Create specific Php-Fpm user.
RUN useradd phpfpm && \
    groupadd phpfpm && \
    usermod -g phpfpm phpfpm && \
    usermod -G users phpfpm

# Fix Php links.
RUN ln -s /usr/bin/php7 /usr/bin/php && \
    ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm && \
    ln -s /etc/php7 /etc/php && \
    ln -s /usr/lib/php7 /usr/lib/php

# Composer last version.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo "PATH=$PATH:~/.composer/vendor/bin" >> /root/.bashrc

# Drush last version.
RUN curl -sS http://files.drush.org/drush.phar -L -o drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    chmod +x /usr/local/bin/drush && \
    drush init -y >/dev/null

# Drupal console last version.
RUN curl -sS https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \
    drupal init >/dev/null

# Prepare php logs.
RUN mkdir -p /var/log/php && \
    touch /var/log/php/php-error.log && \
    touch /var/log/php/php-fpm.log

# Clean.
RUN rm -f /var/cache/apk/*

# Config and run script.
COPY config/php.ini /etc/php/php.ini
COPY config/php-fpm.conf /etc/php/php-fpm.conf
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 9000

VOLUME ["/var/log/php"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
