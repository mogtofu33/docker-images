FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=
#ENV LOCAL_GID=

ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV COMPOSER_VERSION 1.4.2

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    php7 php7-common php7-fpm php7-cgi \
    php7-json php7-zlib php7-phar php7-openssl php7-sockets \
    php7-pdo php7-pdo_mysql php7-mysqlnd php7-mysqli \
    php7-pdo_pgsql php7-pgsql php7-sqlite3 \
    php7-iconv php7-mcrypt php7-intl php7-mbstring php7-pcntl php7-tokenizer \
    php7-ctype  php7-bcmath php7-dom php7-xsl php7-xml php7-xmlrpc php7-xmlreader \
    php7-soap php7-ldap php7-opcache php7-xdebug php7-apcu php7-phpdbg \
    php7-posix php7-session php7-curl php7-gd php7-exif \
    php7-zip php7-bz2 php7-sysvmsg php7-sysvsem php7-sysvshm \
    php7-ftp php7-gmp php7-imap php7-calendar \
    php7-tidy php7-wddx php7-enchant php7-embed php7-litespeed php7-pear \
    php7-memcached php7-redis \
    php7-apache2 apache2 apache2-ssl apache2-utils \
    apache2-ldap apache2-proxy \
    mysql-client postgresql-client \
    rsync openssh openssl

# Fix Apache.
RUN mv /etc/apache2/conf.d/ssl.conf /etc/apache2/conf.d/ssl.conf.disabled && \
    mv /etc/apache2/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf.disabled && \
    echo "ServerName localhost:80" >> /etc/apache2/httpd.conf

# Install Composer with prestissimo and phpcs with Drupal standards.
RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
    && php -r " \
      \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
      \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
      if (!hash_equals(\$signature, \$hash)) { \
          unlink('/tmp/installer.php'); \
          echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
          exit(1); \
      }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm /tmp/installer.php \
    && composer --ansi --version --no-interaction
RUN /usr/bin/composer global require "hirak/prestissimo:^0.3"
RUN /usr/bin/composer global require "drupal/coder"
RUN /composer/vendor/bin/phpcs --config-set installed_paths /composer/vendor/drupal/coder/coder_sniffer

# Copy root bashrc config for Apache user when running cmd.
RUN cp /root/.bashrc /var/www/.bashrc && \
    chown apache:www-data /var/www/.bashrc

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    touch /var/log/apache2/php-error.log && \
    chown -R apache:www-data /var/log/apache2

# Clean.
RUN rm -rf /var/cache/apk/*

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", "/var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
