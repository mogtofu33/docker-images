# Drupal Docker Compose - Docker images

My Docker Images to use with Drupal Docker Compose project.

* [Docker Compose Drupal](https://github.com/Mogtofu33/docker-compose-drupal)

## Build and test

Alpine base image Dockerfile template located in [/alpine-base](./alpine-base)

    make build

    make test
    # If everything is ok, should return build success and php version.
    make clean

Then commit changes.