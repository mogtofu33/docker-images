#!/bin/bash
# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

# Set-up composer
if [[ $SETUP_COMPOSER ]]; then
  echo "Set-up Composer..."
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  echo "PATH=$PATH:~/.composer/vendor/bin" >> /root/.bashrc
  # Set-up prestissimo plugin.
  /usr/local/bin/composer global require "hirak/prestissimo:^0.3"
fi

# Set-up Drush
if [[ $SETUP_DRUSH ]]; then
  echo "Set-up Drush..."
  curl -sS http://files.drush.org/drush.phar -L -o drush.phar && \
    mv drush.phar /usr/local/bin/drush && \
    chmod +x /usr/local/bin/drush
  drush init -y >/dev/null &2>&1
fi

# Set-up Drupal console
if [[ $SETUP_CONSOLE ]]; then
  echo "Set-up Drupal console..."
  curl -sS https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal
  drupal init >/dev/null
fi

# Apache yelling about pid on container restart.
rm -rf /run/apache2
mkdir -p /run/apache2
chown apache:www-data /run/apache2
echo "[i] Starting Apache..."
# Run apache httpd daemon.
httpd -D FOREGROUND