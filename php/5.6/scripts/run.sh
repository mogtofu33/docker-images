#!/bin/bash

# Common commands for permissions fix.
/scripts/fix_permissions.sh

echo "[i] Starting Php-fpm..."

exec /usr/sbin/php-fpm -F
