# Docker MySQL/MariaDB image for Drupal

Based on my basic Alpine image: https://github.com/Mogtofu33/docker-alpine-base

* Used for https://github.com/Mogtofu33/docker-compose-drupal

A drupal database with user / pass drupal is created at first launch.

Variables:
- LOCAL_UID # Change the mysql uid
- LOCAL_GID # Change the mysql gid

Volumes:
- /var/lib/mysql # Database
- /var/log/mysql # Logs

