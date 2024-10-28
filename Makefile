export PATH := $(PWD)/.venv/bin:$(PATH)
export VIRTUAL_ENV := $(PWD)/.venv
export SRC_DIR := $(shell ls */main.py | xargs dirname)

PYTHON := python3.11
COLOR="\033[36m%-30s\033[0m %s\n"

ENV_EXISTS=0

.PHONY: .env .venv deploy migrations
.DEFAULT_GOAL := help

ifeq ($(wildcard .env), .env)
    include .env
    export $(shell sed 's/=.*//' .env)
    ENV_EXISTS=1
endif

.venv:
	@$(PYTHON) -m venv $(VIRTUAL_ENV)
	pip install --upgrade pip

.rm-venv:
	@if [ -d $(VIRTUAL_ENV) ]; then rm -rf $(VIRTUAL_ENV); fi

install: .venv ## Create .venv and install dependencies.
	@if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

reinstall: .rm-venv install ## Remove .venv if exists, create a new .venv and install dependencies.

install-dev: install ## Create .venv and install dev dependencies.
	if [ -f requirements-dev.txt ]; then pip install -r requirements-dev.txt; fi

reinstall-dev: .rm-venv install-dev ## Remove .venv if exists, create a new .venv and install dev dependencies.

start:  ## Start api for development
	@export $(cat .env) && fastapi dev app/main.py

build: ## Create docker image
	@docker image build -t api:001 .

image-to-cluster: ## Upload image to cluster
	@docker save api:001 > api.tar
	@microk8s ctr image import api.tar
	@rm api.tar

worker:  ## Start worker for development mode
	@export $(cat .env)  && cd app && celery -A celery -A celery_worker worker --loglevel=info

update-cluster:  ## Update cluster
	@microk8s kubectl apply -f manifests/api/secret.yaml
	@microk8s kubectl apply -f manifests/api/deployment.yaml
	@microk8s kubectl apply -f manifests/api/service.yaml
	@microk8s kubectl apply -f manifests/api/hpa.yaml

	@microk8s kubectl apply -f manifests/redis/deployment.yaml
	@microk8s kubectl apply -f manifests/redis/service.yaml

	@microk8s kubectl apply -f manifests/worker/deployment.yaml
	@microk8s kubectl apply -f manifests/worker/hpa.yaml

	@microk8s kubectl apply -f manifests/ingress.yaml

deploy: build image-to-cluster update-cluster # Build image and update cluster

deploy-local: build # Build image and start locally
	@docker run -p 8000:8000 api:001

help: ## Show documentation.
	@for makefile_file in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z_-]+:.*?##' $$makefile_file | sort | awk 'BEGIN {FS = ":.*?##"}; {printf ${COLOR}, $$1, $$2}'; \
	done