import time
import random

from src.core.loggers import logger
from src.core.celery.app import celery


@celery.task(bind=True)
def task(self):
    logger.info("Task ID: %s", self.request.id)

    total = random.choice([3, 5, 7])

    for i in range(total):
        logger.info("Processing: %s", i)
        time.sleep(1)
