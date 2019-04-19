#!/bin/bash

# Fix Php links if needed.
if ! [ -f /usr/sbin/php-fpm ]; then
  ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm
fi

if ! [ -f /usr/bin/php ]; then
  ln -s /usr/bin/php7 /usr/bin/php
fi

# Add composer folder links for cache.
if ! [ -d /composer ]; then
  ln -s /root/.composer/ /composer
fi

if ! [ -d /.composer ]; then
  ln -s /root/.composer/ /.composer
fi

# Common commands for permissions fix.
/scripts/fix_permissions.sh

echo "[i] Starting Php-fpm..."

exec /usr/sbin/php-fpm -F
