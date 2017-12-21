#!/bin/bash

openssl genrsa -des3 -passout pass:x -out /etc/ssl/apache2/server.key.protected 2048
openssl rsa -passin pass:x -in /etc/ssl/apache2/server.key.protected -out /etc/ssl/apache2/server.key
# rm server.key.protected
openssl req -new -key /etc/ssl/apache2/server.key -out /etc/ssl/apache2/server.csr \
    -subj "/C=NZ/ST=Canterbury/L=Christchurch/O=OrgName/OU=IT Department/CN=example.com"
openssl x509 -req -days 365 -in /etc/ssl/apache2/server.csr -signkey /etc/ssl/apache2/server.key -out /etc/ssl/apache2/server.crt
