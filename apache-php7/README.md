# Docker Apache/Php7 image for Drupal dev

* Used for https://github.com/Mogtofu33/docker-compose-drupal

Based on my basic Alpine Edge image: https://github.com/Mogtofu33/docker-alpine-edge-base

Include:
- Composer
- Drush
- Drupal console

Volumes:
- /www              # Root of your Php app.
- /var/log/apache2  # Apache logs
- /var/log/php      # Php logs

Note: Drush alias is supported with an aliases.drushrc.php under /www/drush folder (/app should be a volume with your php code).

If this file is in your /www/drush folder, you can launch Drush commands from your host:
* docker exec -it MY_CONTAINER drush @ALIAS DRUSH_CMD

A good method is to add an alias to your host.
