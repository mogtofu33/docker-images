FROM mogtofu33/alpine-base:1.0

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1001 \
#    LOCAL_GID=1001

# Install Php extensions, Drush need mysql/postgresql-client and rsync.
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
    mysql-client postgresql-client \
    rsync openssh

# Create specific Php-Fpm user.
RUN useradd phpfpm && \
    groupadd phpfpm && \
    usermod -g phpfpm phpfpm && \
    usermod -G users phpfpm

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
