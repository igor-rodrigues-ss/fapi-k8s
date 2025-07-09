export PATH := $(PWD)/.venv/bin:$(PATH)
export VIRTUAL_ENV := $(PWD)/.venv
export SRC_DIR := $(shell ls */main.py | xargs dirname)

PYTHON := python3.12
COLOR="\033[36m%-30s\033[0m %s\n"

ENV_EXISTS=0

.PHONY: .env .venv deploy migrations docs
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

.install-hook:
	@echo "make lint" > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit

install: .venv ## Create .venv and install dependencies.
	@if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

reinstall: .rm-venv install ## Remove .venv if exists, create a new .venv and install dependencies.

install-dev: install .install-hook ## Create .venv and install dev dependencies.
	if [ -f requirements-dev.txt ]; then pip install -r requirements-dev.txt; fi

reinstall-dev: .rm-venv install-dev ## Remove .venv if exists, create a new .venv and install dev dependencies.

clean: ## Clean unnecessary files.
	@rm -rf .pytest_cache .coverage
	@find . -name _pycache_ | xargs rm -rf
	@find tests -name _pycache_ | xargs rm -rf

lint: ## Lint code.
	@black --line-length=100 --target-version=py38 --check src
	@flake8 --max-line-length=250 --ignore=E402,W503 --exclude .venv,__app src

format: ## Format code.
	@black --line-length=100 --target-version=py38 .

coverage: ## Run coverage tests.
	@pytest --cov-config=.coveragerc --cov=src tests/ --cov-fail-under=95 --cov-report term-missing

test: ## Run unit tests.
	@pytest

start:  ## Start api for development
	@export $(cat .env) >> /dev/null && fastapi dev src/main.py

celery: ## Start worker for development mode
	@export $(cat .env) >> /dev/null && celery -A src.core.celery.app worker -E --loglevel=info --beat

flower: ## Start flower for development mode
	@export $(cat .env) >> /dev/null && celery -A src.core.celery.app flower -E --loglevel=info --port=5555

redis: ## [Host]: Start redis.
	@sudo docker run -p 6379:6379 -d redis

docs: ## Start live docs server
	@cd docs && mkdocs serve

build: ## Create docker image
	@docker image build -t fapi-k8s:001 .

image-to-cluster: ## Upload image to cluster
	@docker save fapi-k8s:001 > fapi-k8s.tar
	@microk8s ctr image import fapi-k8s.tar
	@rm fapi-k8s.tar

update-cluster:  ## Update cluster
	@microk8s kubectl apply -f manifests/secret.yaml

	@microk8s kubectl apply -f manifests/api/deployment.yaml
	@microk8s kubectl apply -f manifests/api/hpa.yaml
	@microk8s kubectl apply -f manifests/worker/statefulset.yaml
	@microk8s kubectl apply -f manifests/worker/hpa.yaml

	@microk8s kubectl apply -f manifests/ingress.yaml

	@microk8s kubectl rollout restart deployment/fapi-k8s
	@microk8s kubectl rollout restart statefulset/worker

deploy: build image-to-cluster update-cluster # Build image and update cluster

deploy-local: build # Build image and start locally
	@docker run -p 8000:8000 api:001

help: ## Show documentation.
	@for makefile_file in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z_-]+:.*?##' $$makefile_file | sort | awk 'BEGIN {FS = ":.*?##"}; {printf ${COLOR}, $$1, $$2}'; \
	done