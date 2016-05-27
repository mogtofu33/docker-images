FROM mogtofu33/alpine-base:1.0

MAINTAINER moimog33@gmail.com

# ENV LOCAL_UID=1001 \
    # LOCAL_GID=1001

# Variables for PostgreSQL.
ENV PGDATA=/var/lib/postgresql/data \
    POSTGRES_USER=drupal \
    POSTGRES_PASSWORD=drupal \
    POSTGRES_DB=drupal

RUN apk --update add "postgresql<9.6" "postgresql-contrib<9.6" && \
    curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

# Copy startup script.
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 5432

VOLUME ["/var/lib/postgresql/data"]

CMD ["/scripts/run.sh", "postgres"]
