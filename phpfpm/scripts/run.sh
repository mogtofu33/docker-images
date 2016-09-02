#!/bin/bash

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh phpfpm:phpfpm $LOCAL_UID:$LOCAL_GID
fi

# Set-up third party tools if needed.
/scripts/install_tools.sh

echo "[i] Starting Php-Fpm..."
# Run apache httpd daemon.
/usr/bin/php-fpm -F
