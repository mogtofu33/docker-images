#!/bin/sh

# Fix access docker.sock for our dashboard.
if [ -e /var/run/docker.sock ]; then
  chown apache:www-data /var/run/docker.sock
fi