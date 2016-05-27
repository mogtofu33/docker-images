FROM alpine:edge

MAINTAINER moimog33@gmail.com

# Configurable settings.
ENV TIMEZONE        Pacific/Auckland

# System settings
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV TERM            xterm

# Basic setup.
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade

# With minimal apps.
RUN apk add --update \
    bash \
    shadow \
    curl \
    wget \
    tzdata

# Set timezone.
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone

# Copy config.
COPY config/bashrc /root/.bashrc
COPY config/bash_aliases /root/.bash_aliases

# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash
RUN ln -s /bin/sh /sh

# Cleanup.
RUN apk del tzdata && \
    rm -rf /var/cache/apk/*

# Prepare www folder.
RUN mkdir -p /www

# Prepare scripts folde and set our script.
RUN mkdir /scripts && \
    chmod -R 755 /scripts
COPY ./scripts/change_uid_gid.sh /scripts/change_uid_gid.sh
RUN chmod +x /scripts/change_uid_gid.sh
