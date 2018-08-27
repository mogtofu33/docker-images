#!/bin/bash

# Common commands for permissions fix.
/scripts/init.sh

echo "[i] Starting Php-fpm..."

exec /usr/sbin/php-fpm -F
