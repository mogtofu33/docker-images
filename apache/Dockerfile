FROM mogtofu33/alpine-base:latest

MAINTAINER moimog33@gmail.com

# Set specific uid/gid to web server user to fix permissions issues.
ENV LOCAL_UID=1001
ENV LOCAL_GID=1001

# Apache packages.
# https://pkgs.alpinelinux.org/packages?name=apache2*&branch=v3.6&arch=x86_64
RUN apk add --update \
    apache2 \
    apache2-utils \
    apache2-doc \
    apache2-error \
    apache2-http2 \
    apache2-icons \
    apache2-ldap \
    apache2-proxy \
    apache2-ssl \
    apache-mod-fcgid

# Other packages needed.
RUN apk add --update \
    rsync \
    openssh \
    openssl

# Copy root bashrc config for Apache user when running cmd.
RUN cp /root/.bashrc /var/www/.bashrc && \
    chown apache:www-data /var/www/.bashrc

# Fix web root permission, set php and apache logs.
RUN chown -R apache:www-data /var/www

# Clean.
RUN rm -rf /var/cache/apk/*

# Set apache script.
COPY scripts/run.sh /scripts/run.sh
COPY scripts/generate_certificate.sh /scripts/generate_certificate.sh
RUN chmod +x /scripts/run.sh /scripts/generate_certificate.sh

EXPOSE 80
EXPOSE 443

VOLUME ["/var/www/localhost"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
