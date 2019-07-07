#!/bin/bash

if ! [ -f /usr/bin/php ] && [ -f /usr/bin/php7 ]; then
  ln -s /usr/bin/php7 /usr/bin/php
fi

# Common commands for permissions fix.
/scripts/fix_permissions.sh

echo "[i] Starting Php-fpm..."

if [ -f /usr/sbin/php-fpm ]
then
  exec /usr/sbin/php-fpm -F
elif [ -f /usr/sbin/php-fpm7 ]
then
  exec /usr/sbin/php-fpm7 -F
fi