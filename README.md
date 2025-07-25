# FastAPI Celery K8S

[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/release/python-3120/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115.12-blue.svg)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-20.10.7-blue.svg)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28.0-blue.svg)](https://kubernetes.io/)
[![MkDocs](https://img.shields.io/badge/MkDocs-1.6.1-blue.svg)](https://www.mkdocs.org/)
[![Makefile](https://img.shields.io/badge/Makefile-1.0.0-blue.svg)](https://www.gnu.org/software/make/)

## Overview

This project is a modern FastAPI application designed to run on Kubernetes clusters. It showcases the integration of multiple cutting-edge technologies commonly used in modern web development and microservices architecture.

## Features

- High-performance FastAPI backend
- Asynchronous task processing with Celery
- Redis for caching and task queue
- Containerized deployment with Docker
- Kubernetes orchestration with Microk8s
- Live documentation with MkDocs
- Automated tasks with Makefile

## Prerequisites

- Python 3.12
- Docker
- Microk8s
- Redis

## Development

1. Clone the repository:
```bash
git clone https://github.com/igor-rodrigues-ss/fapi-celery-k8s.git
cd fapi-celery-k8s
```

2. Set up the environment:
```bash
make install-dev
```

3. Create .env file in root project based on template.env
```bash
cp template.env .env
# Change env values in .env file
```

4. Build and deploy to Kubernetes:
```bash
make start
```

5. Start celery worker:
```bash
make celery
```

6. Start flower:
```bash
make flower
```

7. Start MkDocs server:
```bash
make docs
```

## Production
0. Make sure you have a Kubernetes cluster running.
```bash
microk8s status
```

1. Build and deploy to Kubernetes:
```bash
make deploy
```

## Architecture Overview

![Cluster Architecture](docs/docs/imgs/arch.png)

The system is built on a Kubernetes cluster architecture with the following key components:

- **API Layer**: Deployed using ReplicaSet for high availability, with automatic scaling based on demand.
- **Worker Layer**: StatefulSets manage worker pods, ensuring stable network identifiers and ordered scaling.
- **Load Balancing**: Ingress controller routes traffic to API services.
- **Message Queue**: Celery + Redis for distributed task processing, with stateful worker pods maintaining individual Redis connections.
- **Scalability**: Horizontal Pod Autoscalers (HPA) for both API and worker pods, scaling based on CPU and memory metrics.
- **Security**: Pods access secrets through Kubernetes secrets store, with secure configuration management.
