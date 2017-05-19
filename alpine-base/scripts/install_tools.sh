#!/bin/bash

# Set-up composer
if [[ $SETUP_COMPOSER == 1 ]]; then
  echo "[i] Set-up Composer..."
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
  echo "PATH=$PATH:~/.composer/vendor/bin" >> $HOME/.bashrc
  # Set-up prestissimo plugin.
  /usr/local/bin/composer global require "hirak/prestissimo:^0.3"
fi

# Set-up Drush
if [[ $SETUP_DRUSH == 1 ]]; then
  echo "[i] Set-up Drush..."
  curl -sS http://files.drush.org/drush.phar -L -o drush.phar && \
  mv drush.phar /usr/local/bin/drush && \
  chmod +x /usr/local/bin/drush
  drush init -y >/dev/null &2>&1
fi

# Set-up Drupal console
if [[ $SETUP_CONSOLE == 1 ]]; then
  echo "[i] Set-up Drupal console..."
  curl -sS https://drupalconsole.com/installer -L -o drupal.phar && \
  mv drupal.phar /usr/local/bin/drupal && \
  chmod +x /usr/local/bin/drupal
  drupal init >/dev/null &2>&1
  echo 'source "$HOME/.console/console.rc" 2>/dev/null' >> $HOME/.bashrc
fi
