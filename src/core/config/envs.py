import os
import logging


CELERY_BROKER_URL = os.environ["CELERY_BROKER_URL"]


LOG_LEVEL = os.environ.get("LOG_LEVEL", logging.INFO)
