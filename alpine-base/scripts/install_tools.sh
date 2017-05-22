#!/bin/bash

# Set-up composer
if [[ $SETUP_COMPOSER == 1 ]]; then
  if [ ! -f "/usr/local/bin/composer" ]; then
    echo "[i] Set-up Composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    echo "PATH=$PATH:~/.composer/vendor/bin" >> $HOME/.bashrc
    # Set-up prestissimo plugin.
    /usr/local/bin/composer global require "hirak/prestissimo:^0.3"
  else
    echo "[i] Composer already here!"
  fi
fi
