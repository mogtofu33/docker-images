#!/bin/sh

# (try to) Fix access docker.sock for our dashboard.
/scripts/fix_docker_sock.sh

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

echo "[i] Starting Php-fpm..."
# exec /usr/sbin/php-fpm --allow-to-run-as-root --nodaemonize
exec /usr/sbin/php-fpm -F
