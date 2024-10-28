import time
import random

from celery import Celery
from settings import REDIS_URL


celery_app = Celery('fapi-k8s', broker=REDIS_URL, backend=REDIS_URL, broker_connection_retry_on_startup=True)


@celery_app.task()
def heavy_processing():
    total = random.choice([3, 5, 7])

    for i in range(total):
        print("Processing:", i)
        time.sleep(1)