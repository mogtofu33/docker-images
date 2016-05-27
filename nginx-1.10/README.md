# Docker Nginx 1.8 image for Drupal dev

Based on my basic Alpine edge image: https://github.com/Mogtofu33/docker-alpine-edge-base

* Used for https://github.com/Mogtofu33/docker-compose-drupal

Variables:
- LOCAL_UID # Change the nginx uid
- LOCAL_GID # Change the nginx gid

Volumes:
- /www/drupal
- /var/log/nginx
