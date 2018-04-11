#!/bin/sh

# Fix access docker.sock for our dashboard.
# if [ -e /var/run/docker.sock ]; then
#   chown apache:www-data /var/run/docker.sock
# fi

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

echo "[i] Starting Php-fpm..."
# exec /usr/sbin/php-fpm7 --allow-to-run-as-root --nodaemonize
exec /usr/sbin/php-fpm7 -F
