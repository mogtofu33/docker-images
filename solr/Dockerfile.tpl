FROM solr:$SOLR_VERSION-alpine

LABEL maintainer="dev-drupal.com"

ENV EXTRA_ACCESS="/solr/drupal"

# Add specific Drupal config.
RUN mkdir -p /opt/solr/server/solr/mycores/d8/conf/ && \
    mkdir -p /opt/solr/server/solr/mycores/d8/data/
ADD config/conf/ /opt/solr/server/solr/mycores/d8/conf/
COPY config/core.properties /opt/solr/server/solr/mycores/d8/core.properties

EXPOSE 8983
