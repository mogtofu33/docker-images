FROM alpine:$ALPINE_VERSION

# Configurable settings.
ENV TIMEZONE        $TIMEZONE

# System settings
ENV LANG            en_US.UTF-8
ENV LC_ALL          en_US.UTF-8
ENV TERM            xterm

# Basic setup.
RUN apk update && \
    apk upgrade

# With minimal apps.
RUN apk add --update --no-cache \
    git \
    bash \
    shadow \
    curl \
    wget \
    lynx \
    tzdata \
    rsync \
    openssh \
    openssl

# Set timezone.
RUN cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    echo "$TIMEZONE" > /etc/timezone

# Copy config.
COPY config/bashrc /root/.bashrc

# Usefull bash alias for docker exec.
RUN ln -s /bin/bash /bash && \
    ln -s /bin/sh /sh

# Cleanup.
RUN apk del tzdata && \
    rm -rf /var/cache/apk/*

# Prepare folders and set our scripts.
RUN mkdir /scripts && \
    chmod -R 755 /scripts

COPY ./scripts /scripts/

RUN chmod -R +x /scripts/*.sh
