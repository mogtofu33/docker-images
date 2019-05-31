# Drupal Docker Compose - Docker images

[![pipeline status](https://gitlab.com/mog33/docker-images/badges/master/pipeline.svg)](https://gitlab.com/mog33/docker-images/commits/master)

Alpine base
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/alpine-base.svg)](https://hub.docker.com/r/mogtofu33/alpine-base/)
[![Image size](https://images.microbadger.com/badges/image/mogtofu33/alpine-base.svg)](https://microbadger.com/images/mogtofu33/alpine-base)

Php
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/php.svg)](https://hub.docker.com/r/mogtofu33/php/)
[![Image size](https://images.microbadger.com/badges/image/mogtofu33/php.svg)](https://microbadger.com/images/mogtofu33/php)

Apache
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/apache.svg)](https://hub.docker.com/r/mogtofu33/apache/)
[![Image size](https://images.microbadger.com/badges/image/mogtofu33/apache.svg)](https://microbadger.com/images/mogtofu33/apache)

Solr
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/solr.svg)](https://hub.docker.com/r/mogtofu33/solr/)
[![Image size](https://images.microbadger.com/badges/image/mogtofu33/solr.svg)](https://microbadger.com/images/mogtofu33/solr)

Dashboard
[![Docker Build Status](https://img.shields.io/docker/build/mogtofu33/dashboard.svg)](https://hub.docker.com/r/mogtofu33/dashboard/)
[![Image size](https://images.microbadger.com/badges/image/mogtofu33/dashboard.svg)](https://microbadger.com/images/mogtofu33/dashboard)

My Docker Images to use with Drupal Docker Compose project.

* [Docker Compose Drupal](https://github.com/Mogtofu33/docker-compose-drupal)

## Build and test

### Gitlab-CI

Build, test and release to Docker Hub.

* [Gitlab-CI Pipelines](https://gitlab.com/mog33/docker-images/pipelines)

### Locally

    make build

    make test
    # If everything is ok, should return build success and some infos.
    make clean

Then commit changes.
