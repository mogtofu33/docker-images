#!/bin/sh

echo "[i] Starting Solr..."
# Run solr ignoring run as root warning.
/opt/solr/bin/solr -f
