.PHONY = all build test update
COMPOSER_VERSION ?= 1.6.3
COMPOSER_INSTALLER_URL ?= https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer
COMPOSER_INSTALLER_HASH ?= 544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061
COMPOSER_LIBRARIES ?= "hirak/prestissimo:^0.3 drupal/coder"

all: build test

build:
  # docker build -t composer:1.6 -t composer:1.6.3 -t composer:1 -t composer:latest 1.6

test:
  # docker run -t composer:latest --no-ansi | grep 'Composer version 1.6.3'
  # docker run -t composer:latest /bin/bash --version
  # docker run -t composer:1 --no-ansi | grep 'Composer version 1.6.3'
  # docker run -t composer:1 /bin/bash --version
  # docker run -t composer:1.6 --no-ansi | grep 'Composer version 1.6.3'
  # docker run -t composer:1.6 /bin/bash --version
  # docker run -t composer:1.5 --no-ansi | grep 'Composer version 1.5.6'
  # docker run -t composer:1.5 /bin/bash --version
  # docker run -t composer:1.4 --no-ansi | grep 'Composer version 1.4.3'
  # docker run -t composer:1.4 /bin/bash --version

update:
  @echo "Update to Composer "$(value COMPOSER_VERSION) $(value COMPOSER_LIBRARIES)
  # @find . -type f -name 'Dockerfile' -exec \
  #   @sed -e 's/ENV COMPOSER_VERSION.*/ENV COMPOSER_VERSION $(value COMPOSER_VERSION)/' \
  #       -e 's/ENV COMPOSER_INSTALLER_URL.*/ENV COMPOSER_INSTALLER_URL $(value COMPOSER_INSTALLER_URL)/' \
  #       -e 's/ENV COMPOSER_INSTALLER_HASH.*/ENV COMPOSER_INSTALLER_HASH $(value COMPOSER_INSTALLER_HASH)/' \
  #       -e 's/ENV COMPOSER_LIBRARIES.*/ENV COMPOSER_LIBRARIES $(value COMPOSER_LIBRARIES)/' \
  #       ;
