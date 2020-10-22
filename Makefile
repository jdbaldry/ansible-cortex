.ONESHELL:
.DELETE_ON_ERROR:
SHELL       := bash
SHELLOPTS   := -euf -o pipefail
MAKEFLAGS   += --warn-undefined-variables
MAKEFLAGS   += --no-builtin-rule

# Adapted from https://suva.sh/posts/well-documented-makefiles/
.PHONY: help
help: ## Display this help
help:
	@awk 'BEGIN {FS = ": ##"; printf "Usage:\n  make <target>\n\nTargets:\n"} /^[a-zA-Z0-9_\.\-\/%]+: ##/ { printf "  %-45s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

define molecule_cmd
	docker run --rm -it \
		-v "$$(pwd)":/tmp/$(basename "$${PWD}"):ro \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /tmp/$(basename "$${PWD}") \
		quay.io/ansible/molecule:3.0.8 \
		molecule $(1) $(2)
endef

.PHONY: test
test: ## Run Molecule tests
test:
	$(call molecule_cmd,test,$(MOLECULE_ARGS))

.PHONY: converge
converge: ## Run Molecule converge command
converge:
	$(call molecule_cmd,converge,$(MOLECULE_ARGS))

.PHONY: lint
lint: ## Lint ansible files
lint:
	$(call molecule_cmd,lint,$(MOLECULE_ARGS))

.PHONY: build
build: ## Build all docker images
build: platforms/ubuntu-systemd/bionic/.uptodate platforms/debian-systemd/buster/.uptodate platforms/centos-systemd/8/.uptodate

.PHONY: publish
publish: ## Publish all docker images
publish: platforms/ubuntu-systemd/bionic/.published platforms/debian-systemd/buster/.published platforms/centos-systemd/8/.published

platforms/ubuntu-systemd/bionic/.uptodate: ## Build ubuntu-systemd:bionic platform image
platforms/ubuntu-systemd/bionic/.uptodate: platforms/ubuntu-systemd/bionic/Dockerfile
	docker build -t jdbgrafana/ubuntu-systemd:bionic $(@D)
	touch $@

platforms/debian-systemd/buster/.uptodate: ## Build debian-systemd:buster platform image
platforms/debian-systemd/buster/.uptodate: platforms/debian-systemd/buster/Dockerfile
	docker build -t jdbgrafana/debian-systemd:buster $(@D)
	touch $@

platforms/centos-systemd/8/.uptodate: ## Build centos-systemd:8 platform image
platforms/centos-systemd/8/.uptodate: platforms/centos-systemd/8/Dockerfile
	docker build -t jdbgrafana/centos-systemd:8 $(@D)
	touch $@

platforms/ubuntu-systemd/bionic/.published: ## Publish ubuntu-systemd:bionic platform image
platforms/ubuntu-systemd/bionic/.published: platforms/ubuntu-systemd/bionic/.uptodate
	docker push jdbgrafana/ubuntu-systemd:bionic
	touch $@

platforms/debian-systemd/buster/.published: ## Build debian-systemd:buster platform image
platforms/debian-systemd/buster/.published: platforms/debian-systemd/buster/Dockerfile
	docker push jdbgrafana/debian-systemd:buster
	touch $@

platforms/centos-systemd/8/.published: ## Publish centos-systemd:8 platform image
platforms/centos-systemd/8/.published: platforms/centos-systemd/8/.uptodate
	docker push jdbgrafana/centos-systemd:8
	touch $@
