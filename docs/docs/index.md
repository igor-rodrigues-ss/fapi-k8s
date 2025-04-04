# FastAPI K8S

[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/release/python-3120/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100.0-brightgreen.svg)](https://fastapi.tiangolo.com/)
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
- Beanie for MongoDB ODM
- Containerized deployment with Docker
- Kubernetes orchestration with Microk8s
- Live documentation with MkDocs
- Automated tasks with Makefile
- Automated tests with pytest

## Prerequisites

- Python 3.12
- Docker
- Microk8s
- MongoDB
- Redis

## Development

1. Clone the repository:
```bash
git clone https://github.com/igor-rodrigues-ss/fapi-k8s.git
cd fapi-k8s
```

2. Set up the environment:
```bash
make install-dev
```

3. Build and deploy to Kubernetes:
```bash
make start
```

4. Start celery worker:
```bash
make celery
```

5. Start flower:
```bash
make flower
```

6. Start MkDocs server:
```bash
make docs
```

4. Run tests:
```bash
make test
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


## License

This project is licensed under the MIT License - see the LICENSE file for details.
