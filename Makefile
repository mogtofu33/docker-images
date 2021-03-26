# Makefile for Docker Compose Drupal images.

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

php_build_7:
	$(call php_build,7.4)

php_build_8:
	$(call php_build,8.0)

solr_build:
	$(call solr_build,7)

build: php_build_7 php_build_8 solr_build

test_base:
	$(call docker_build_run,test_base,./alpine-base,bash --version)

test_php_7:
	$(call docker_build,test_base,alpine-base)
	$(call set_from_test,./php/7.4,test_base)
	$(call docker_build_run,test_php_7_4,./php/7.4,php -v)
	$(call revert_set_from_test,./php/7.4)

test_php_8:
	$(call docker_build,test_base,alpine-base)
	$(call set_from_test,./php/8.0,test_base)
	$(call docker_build_run,test_php_8,./php/8.0,php -v)
	$(call revert_set_from_test,./php/8.0)

test_php: php_build_7 php_build_8 test_php_7 test_php_8

test_solr_7: solr_build
	$(call docker_build_run,test_solr_7,./solr/7,wget -q -O - "http://localhost:8983/solr/d8/admin/ping?wt=json")

test_solr: solr_build test_solr_7

test_apache:
	$(call docker_build,test_base,alpine-base)
	$(call set_from_test,./apache,test_base)
	$(call docker_build_run,test_apache,./apache,httpd -t -D DUMP_RUN_CFG)
	$(call revert_set_from_test,apache)

test: clean-containers test_base test_apache test_solr test_php test_solr

clean-files:
	# clean php images.
	@rm -rf ./php/*/scripts;
	# clean solr images.
	@rm -f ./solr/*/config/core.properties;
	@rm -rf ./solr/*/config/conf/lang;
	@rm -rf ./solr/*/config/conf/*.txt;

clean-containers:
	# clean base.
	$(call docker_clean,test_base)
	# clean php.
	$(call docker_clean,test_php_7)
	$(call docker_clean,test_php_8)
	# clean solr.
	$(call docker_clean,test_solr_7)

clean-images:
	-docker rmi test_base;
	-docker rmi test_php_7;
	-docker rmi test_php_8;
	-docker rmi test_solr_7;

clean: clean-files clean-containers
	# Run clean-images to remove images.

.PHONY: build test clean
