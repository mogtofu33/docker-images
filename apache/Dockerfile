FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000 \
    LOCAL_GID=1000

# Install Php extensions, Apache and database client/rsync for Drush.
RUN apk add --update \
    apache2 apache2-proxy apache2-ssl \
    rsync openssh openssl

# Prepare Web root and Apache.
RUN mkdir -p /www && \
    chown -R apache:www-data /www && \
    mkdir /etc/apache2/vhost && \
    chown -R apache:apache /etc/apache2/vhost && \
    mkdir /run/apache2 && \
    chown -R apache:www-data /run/apache2

# Prepare php and apache logs.
RUN mkdir -p /var/log/apache2 && \
    chown -R apache:www-data /var/log/apache2

# Clean.
RUN rm -rf /var/cache/apk/*

# Set Apache config.
COPY config/httpd.conf /etc/apache2/httpd.conf
COPY config/vhost.conf /etc/apache2/vhost/vhost.conf
COPY config/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf

# Set apache script
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/www", "/etc/apache2/vhost", /var/log/apache2"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
