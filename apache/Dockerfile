FROM mogtofu33/alpine-base:3.13

LABEL maintainer="dev-drupal.com"

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1000
ENV LOCAL_GID=1000

# Leave empty to not generate a certificate.
ENV GENERATE_APACHE_CERTIFICATE=

# Apache packages.
# https://pkgs.alpinelinux.org/packages?name=apache*&branch=v3.9&arch=x86_64
RUN apk add --update --no-cache \
    apache2 \
    apache2-utils \
    apache2-error \
    apache2-http2 \
    apache2-icons \
    apache2-ldap \
    apache2-proxy \
    apache2-proxy-html \
    apache2-ssl \
    apache2-ctl \
    apache-mod-fcgid \
    libxml2-dev

COPY ./scripts/run.sh /scripts/run.sh

# Fix proxy error by disabling config.
RUN mv /etc/apache2/conf.d/proxy.conf /etc/apache2/conf.d/proxy.conf.dis && \
  # Copy root bashrc config for Apache user when running cmd.
  cp /root/.bashrc /var/www/.bashrc && \
  # Fix web root permission, set php and apache logs.
  chown -R apache:www-data /var/www && \
  # Set Apache script.
  chmod +x /scripts/run.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
