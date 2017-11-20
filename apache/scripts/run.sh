#!/bin/sh

# Fix access docker.sock for our dashboard.
if [ -e /var/run/docker.sock ]; then
  chown apache:www-data /var/run/docker.sock
fi

# Generate ssl certificate if needed.
# /scripts/generate_certificate.sh

# Set uid/gid to fix data permissions.
if [ "$LOCAL_UID" != "" ]; then
  /scripts/change_uid_gid.sh apache:www-data $LOCAL_UID:$LOCAL_GID
fi

# Apache yelling about pid on container restart.
rm -rf /run/apache2
mkdir -p /run/apache2
chown apache:www-data /run/apache2

echo "[i] Starting Apache..."

# Run apache httpd daemon.
exec httpd -D FOREGROUND -f /etc/apache2/httpd.conf
