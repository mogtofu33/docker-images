# Makefile for Docker Compose Drupal images.

define base_build
	# Build base image $(1)
	@mkdir -p ./alpine-base/$(1);
	@TIMEZONE="Pacific/Auckland" ALPINE_VERSION="$(1)" envsubst < "./alpine-base/Dockerfile.tpl" > "./alpine-base/$(1)/Dockerfile";
	@cp -r ./alpine-base/config/ ./alpine-base/$(1)/;
	@cp -r ./alpine-base/scripts/ ./alpine-base/$(1)/;
	# Done!
endef

define php_build
	# Build php $(1)
	@cp -r ./php/scripts/ ./php/$(1)/;
	# Done!
endef

define solr_build
	# Build solr $(1)
	@SOLR_VERSION="$(1)" envsubst < "./solr/Dockerfile.tpl" > "./solr/$(1)/Dockerfile";
	@cp -r ./solr/config/ ./solr/$(1)/;
	# Done!
endef

define docker_build
	docker build -t=$(1) $(2);
endef

define docker_build_run
	-docker stop $(1) && docker rm $(1);
	docker build -t=$(1) $(2) && docker run -d -t --name $(1) $(1) && docker exec $(1) $(3);
endef

define docker_clean
	-docker stop $(1);
	-docker rm $(1);
endef

base_build:
	$(call base_build,3.7)
	$(call base_build,3.8)

php_build:
	$(call php_build,7.1)
	$(call php_build,7.2)

solr_build:
	$(call solr_build,5)
	$(call solr_build,6)
	$(call solr_build,7)

build: base_build php_build solr_build

test: clean-containers test_base test_php test_solr

test_base_3_7: base_build
	$(call docker_build,base_3_7,./alpine-base/3.7)

test_base_3_8: base_build
	$(call docker_build,base_3_8,./alpine-base/3.8)

test_base: base_build test_base_3_7 test_base_3_8

test_php_7_1: php_build
	$(call docker_build_run,test_php_7_1,./php/7.1,php -v)

test_php_7_2: php_build
	$(call docker_build_run,test_php_7_2,./php/7.2,php -v)

test_php: php_build test_php_7_1 test_php_7_2

test_solr_5: solr_build
	$(call docker_build_run,test_solr_5,./solr/5,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr_6: solr_build
	$(call docker_build_run,test_solr_6,./solr/6,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr_7: solr_build
	$(call docker_build_run,test_solr_7,./solr/7,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr: solr_build test_solr_5 test_solr_6 test_solr_7

clean: clean-files clean-containers

clean-files:
	# clean base images.
	@rm -rf ./alpine-base/3.7;
	@rm -rf ./alpine-base/3.8;
	# clean php images.
	@rm -rf ./php/*/scripts;
	# clean solr images.
	@rm -f ./solr/*/config/core.properties;
	@rm -rf ./solr/*/config/conf/lang;
	@rm -rf ./solr/*/config/conf/*.txt;

clean-containers:
	# clean base.
	$(call docker_clean,base_3_7)
	$(call docker_clean,base_3_8)
	# clean php.
	$(call docker_clean,test_php_7_1)
	$(call docker_clean,test_php_7_2)
	# clean solr.
	$(call docker_clean,test_solr_5)
	$(call docker_clean,test_solr_6)
	$(call docker_clean,test_solr_7)

clean-images:
	-docker rmi base_3_7;
	-docker rmi base_3_8;
	-docker rmi test_php_7_1;
	-docker rmi test_php_7_2;
	-docker rmi test_solr_5;
	-docker rmi test_solr_6;
	-docker rmi test_solr_7;

.PHONY: build test clean