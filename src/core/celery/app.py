from celery import Celery

from src.core.config.envs import CELERY_BROKER_URL


celery = Celery("fapi-k8s", broker=CELERY_BROKER_URL, broker_connection_retry_on_startup=True)


celery.autodiscover_tasks(["src.tasks.celery_tasks.heavy_processing"])


celery.conf.timezone = "UTC"
