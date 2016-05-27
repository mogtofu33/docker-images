FROM mogtofu33/docker-alpine-edge-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
#ENV LOCAL_UID=1001 \
#    LOCAL_GID=1001

# Install Nginx
RUN apk add --update nginx

# Clean
RUN rm -rf /var/cache/apk/*

COPY config/nginx.conf /etc/nginx/nginx.conf

COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

# Setup drush aliases.
RUN mkdir -p /www/drush/ /etc/drush/
COPY config/aliases.drushrc.php /www/drush/aliases.drushrc.php
RUN ln -s /www/drush/aliases.drushrc.php /etc/drush/aliases.drushrc.php

EXPOSE 80

VOLUME ["/www", "/var/log/nginx"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
