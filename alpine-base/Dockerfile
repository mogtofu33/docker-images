FROM alpine:3.4

MAINTAINER moimog33@gmail.com

# Configurable settings.
ENV TIMEZONE        Pacific/Auckland

# System settings
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV TERM            xterm

# Basic setup.
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade

# With minimal apps.
RUN apk add --update \
    git \
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

# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash
RUN ln -s /bin/sh /sh

# Cleanup.
RUN apk del tzdata && \
    rm -rf /var/cache/apk/*

# Prepare app folder.
RUN mkdir -p /www

# Prepare scripts folde and set our script.
RUN mkdir /scripts && \
    chmod -R 755 /scripts
COPY ./scripts/change_uid_gid.sh /scripts/change_uid_gid.sh
RUN chmod +x /scripts/change_uid_gid.sh
