FROM mogtofu33/alpine-base:edge

MAINTAINER moimog33@gmail.com

ENV SOLR_USER root
ENV SOLR_UID 8983
ENV SOLR_VERSION 5.5.3

# Install JRE needed for solr.
RUN apk --update add openjdk7-jre

# Install solr.
RUN mkdir -p /opt/solr && \
    wget -nv --output-document=/opt/solr.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz && \
    cd /opt && \
    tar xzf solr.tgz && \
    mv solr-$SOLR_VERSION/* solr/ && \
    rm /opt/solr.tgz* && \
    mkdir -p /opt/solr/server/solr/lib && \
    chown -R $SOLR_USER:$SOLR_USER /opt/solr && \
    rmdir solr-$SOLR_VERSION

# Clean.
RUN rm -rf /var/cache/apk/*

# We just add a core with the search_api_solr config to the base image here.
RUN mkdir -p /opt/solr/server/solr/drupal/data
ADD config/5.x/ /opt/solr/server/solr/drupal/conf/
COPY config/core.properties /opt/solr/server/solr/drupal/core.properties

# Specific logs settings to file, not console.
COPY config/log4j.properties /opt/solr/server/resources/log4j.properties

# Set apache script.
COPY scripts/run.sh /scripts/run.sh
RUN chmod +x /scripts/run.sh

EXPOSE 8983

VOLUME ["/var/log/solr"]

ENTRYPOINT ["/bin/sh" , "/scripts/run.sh"]
