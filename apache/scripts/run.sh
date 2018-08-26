#!/bin/bash

# Common commands for permissions fix.
/scripts/init.sh

# Generate ssl certificate if needed.
if [ "$GENERATE_APACHE_CERTIFICATE" != "" ]; then
  /scripts/generate_apache_certificate.sh
fi

# Apache yelling about pid on container restart.
rm -rf /run/apache2
mkdir -p /run/apache2
chown apache:www-data /run/apache2

echo "[i] Starting Apache..."

# Run apache httpd daemon.
exec httpd -D FOREGROUND -f /etc/apache2/httpd.conf
