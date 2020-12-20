# Makefile for Docker Compose Drupal images.

define base_build
	# Build base image $(1)
	@mkdir -p ./alpine-base/$(1);
	@TIMEZONE="Europe/Paris" ALPINE_VERSION="$(1)" envsubst < "./alpine-base/Dockerfile.tpl" > "./alpine-base/$(1)/Dockerfile";
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
	docker build -t=$(1) $(2)
	@docker run -d -t --name $(1) $(1)
	@echo ""
	@echo ">>>>>>>>>>>>>>>>>>>>>>>> TEST RESULT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@echo ""
	@docker exec $(1) $(3);
	@echo ""
	@echo ">>>>>>>>>>>>>>>>>>>>>>>>> END RESULT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
	@echo ""
	-docker stop $(1)
	-docker rm $(1);
endef

define set_from_test
	@sed -i "s/^FROM/#FROM/g" $(1)/Dockerfile
	@sed -i '1iFROM $(2)' $(1)/Dockerfile
endef

define revert_set_from_test
	@sed -i '1d' $(1)/Dockerfile
	@sed -i "s/#FROM/FROM/g" $(1)/Dockerfile
endef

define docker_clean
	-docker stop $(1);
	-docker rm $(1);
endef

base_build:
	$(call base_build,3.12)

php_build:
	$(call php_build,7.3, base_3_12)
	$(call php_build,7.4, base_3_12)

solr_build:
	$(call solr_build,7)
	$(call solr_build,8)

build: base_build php_build solr_build

test: clean-containers test_base test_php test_solr

test_base_3_12: base_build
	$(call docker_build,base_3_12,./alpine-base/3.12)

test_base: base_build test_base_3_12

test_php_7_3:
	$(call set_from_test,./php/7.3,base_3_10)
	$(call docker_build_run,test_php_7_3,./php/7.3,php -v)
	$(call revert_set_from_test,./php/7.3)
test_php_7_4:
	$(call set_from_test,./php/7.4,base_3_12)
	$(call docker_build_run,test_php_7_4,./php/7.4,php -v)
	$(call revert_set_from_test,./php/7.4)

test_php: php_build test_php_7_3 test_php_7_4

test_solr_7: solr_build
	$(call docker_build_run,test_solr_7,./solr/7,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr_8: solr_build
	$(call docker_build_run,test_solr_8,./solr/8,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr: solr_build test_solr_7 test_solr_8

clean: clean-files clean-containers

clean-files:
	# clean base images.
	@rm -rf ./alpine-base/3.12;
	# clean php images.
	@rm -rf ./php/*/scripts;
	# clean solr images.
	@rm -f ./solr/*/config/core.properties;
	@rm -rf ./solr/*/config/conf/lang;
	@rm -rf ./solr/*/config/conf/*.txt;

clean-containers:
	# clean base.
	$(call docker_clean,base_3_12)
	# clean php.
	$(call docker_clean,test_php_7_3)
	$(call docker_clean,test_php_7_4)
	# clean solr.
	$(call docker_clean,test_solr_7)
	$(call docker_clean,test_solr_8)

clean-images:
	-docker rmi base_3_12;
	-docker rmi test_php_7_3;
	-docker rmi test_php_7_4;
	-docker rmi test_solr_7;
	-docker rmi test_solr_8;

.PHONY: build test clean