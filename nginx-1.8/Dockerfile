FROM mogtofu33/alpine-base:1.0

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

EXPOSE 80

VOLUME ["/www", "/var/log/nginx"]

ENTRYPOINT ["/bin/bash" , "/scripts/run.sh"]
