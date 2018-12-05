# https://hub.docker.com/r/juampynr/drupal8ci/~/dockerfile/
# https://github.com/docker-library/drupal/blob/master/8.6/apache/Dockerfile
FROM drupal:8.6-apache

# Install composer.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
# Put a turbo on composer.
RUN composer global require hirak/prestissimo

# Install Robo CI.
RUN curl -fsSL https://robo.li/robo.phar -o robo.phar \
  && chmod +x robo.phar \
  && mv robo.phar /usr/local/bin/robo

# Install needed programs.
RUN apt-get update && apt-get install -y \
  imagemagick \
  libmagickwand-dev \
  mariadb-client \
  git \
  rsync \
  sudo \
  unzip

# Install mysqli, xdebug, imagick.
RUN docker-php-ext-install mysqli \
  && pecl install imagick xdebug \
  && docker-php-ext-enable imagick xdebug

# Remove the memory limit for the CLI only.
RUN echo 'memory_limit = -1' > /usr/local/etc/php/php-cli.ini

# Remove the vanilla Drupal project that comes with this image.
RUN rm -rf ..?* .[!.]* *

# Change docroot since we use Composer Drupal project.
RUN sed -ri -e 's!/var/www/html!/var/www/html/web!g' /etc/apache2/sites-available/*.conf \
  && sed -ri -e 's!/var/www!/var/www/html/web!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
