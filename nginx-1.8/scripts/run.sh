#!/bin/bash

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  ./scripts/change_uid_gid.sh nginx:www-data $LOCAL_UID:$LOCAL_GID
fi

if [ ! -d /www/drupal ] ; then
  mkdir -p /www/drupal
  chown -R nginx:www-data /www
fi

# Prepare nginx.
mkdir -p /var/log/nginx
mkdir -p /tmp/nginx
chown nginx:www-data /tmp/nginx

echo "[i] Starting Nginx..."
nginx
