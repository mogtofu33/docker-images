FROM alpine:3.13

LABEL maintainer="dev-drupal.com"

ARG TZ='Europe/Paris'

# System settings
ENV DEFAULT_TZ      ${TZ}
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV TERM            xterm

# Basic setup.
RUN apk update && \
    apk upgrade

# With minimal apps.
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    lynx \
    openssh \
    openssl \
    rsync \
    shadow \
    wget \
    tzdata \
    && cp /usr/share/zoneinfo/${DEFAULT_TZ} /etc/localtime \
    && apk del tzdata \
    && rm -rf /var/cache/apk/*

# Copy config.
COPY config/bashrc /root/.bashrc

# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash && \
    ln -s /bin/sh /sh

# Prepare folders and set our scripts.
RUN mkdir /scripts && \
    chmod -R 755 /scripts

COPY ./scripts /scripts/

RUN chmod -R +x /scripts/*.sh
