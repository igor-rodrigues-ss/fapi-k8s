import time
import random
import logging

from src.core.celery.app import celery


logger = logging.getLogger(__name__)


@celery.task(bind=True)
def task(self):
    logger.info("Task ID: %s", self.request.id)

    total = random.choice([3, 5, 7])

    for i in range(total):
        logger.info("Processing: %s", i)
        time.sleep(1)
