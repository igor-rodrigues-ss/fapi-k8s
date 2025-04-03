from celery import Celery

from src.core.config.envs import REDIS_URL


celery = Celery("fapi-k8s", broker=REDIS_URL, broker_connection_retry_on_startup=True)


celery.autodiscover_tasks(["src.tasks.heavy_processing"])


celery.conf.timezone = "UTC"
