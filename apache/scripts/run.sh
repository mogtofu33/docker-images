#!/bin/bash

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

# Set-up third party tools if needed.
/scripts/install_tools.sh

# Apache yelling about pid on container restart.
rm -rf /run/apache2
mkdir -p /run/apache2
chown apache:www-data /run/apache2

echo "[i] Starting Apache..."
# Run apache httpd daemon.
httpd -D FOREGROUND
