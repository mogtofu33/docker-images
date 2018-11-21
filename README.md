# Drupal Docker Compose - Docker images

[![pipeline status](https://gitlab.com/mog33/docker-images/badges/master/pipeline.svg)](https://gitlab.com/mog33/docker-images/commits/master)

My Docker Images to use with Drupal Docker Compose project.

* [Docker Compose Drupal](https://github.com/Mogtofu33/docker-compose-drupal)

## Build and test

### Gitlab-CI

* [Gitlab-CI Pipelines](https://gitlab.com/mog33/docker-images/pipelines)

### Locally

    make build

    make test
    # If everything is ok, should return build success and php version.
    make clean

Then commit changes.
