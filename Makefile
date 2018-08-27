# Makefile for Docker Compose Drupal images.

define base_build
	@mkdir -p ./alpine-base/$(1);
	@TIMEZONE="Pacific/Auckland" ALPINE_VERSION="$(1)" envsubst < "./alpine-base/Dockerfile.template" > "./alpine-base/$(1)/Dockerfile";
	@cp -r ./alpine-base/config/ ./alpine-base/$(1)/;
	@cp -r ./alpine-base/scripts/ ./alpine-base/$(1)/;
endef

define php_build
	@cp -r ./php/scripts/ ./php/$(1)/;
endef

define docker_build
	docker build -t=$(1) $(2);
endef

define docker_build_run
	-docker stop $(1) && docker rm $(1);
	docker build -t=$(1) $(2) && docker run -d -t --name $(1) $(1) && docker exec -it $(1) $(3);
	-docker stop $(1) && docker rm $(1);
endef

define docker_clean
	-docker stop $(1);
	-docker rm $(1);
	-docker rmi $(1);
endef

build:
	# build base image.
	$(call base_build,3.7)
	$(call base_build,3.8)
	# build php images.
	$(call php_build,5.6)
	$(call php_build,7.1)
	$(call php_build,7.2)

test: clean build test_base_3_7 test_base_3_8 test_php_5 test_php_7_1 test_php_7_2

test_base_3_7:
	$(call docker_build,base_3_7,./alpine-base/3.7)

test_base_3_8:
	$(call docker_build,base_3_8,./alpine-base/3.8)

test_php_5:
	$(call docker_build_run,test_php_5,./php/5.6,php -v)

test_php_7_1:
	$(call docker_build_run,test_php_7_1,./php/7.1,php -v)

test_php_7_2:
	$(call docker_build_run,test_php_7_2,./php/7.2,php -v)

clean:
	# clean base images.
	@rm -rf ./alpine-base/3.7;
	@rm -rf ./alpine-base/3.8;
	$(call docker_clean,base_3_7)
	$(call docker_clean,base_3_8)
	# clean php images.
	@rm -rf ./php/5.6/scripts;
	@rm -rf ./php/7.1/scripts;
	@rm -rf ./php/7.2/scripts;
	$(call docker_clean,test_php_5)
	$(call docker_clean,test_php_7_1)
	$(call docker_clean,test_php_7_2)

.PHONY: build test clean