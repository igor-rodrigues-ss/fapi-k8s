import time
import random

from src.celery import celery


@celery.task(bind=True)
def heavy_processing(self):
    print("Task ID:", self.request.id)

    total = random.choice([3, 5, 7])

    for i in range(total):
        print("Processing:", i)
        time.sleep(1)
