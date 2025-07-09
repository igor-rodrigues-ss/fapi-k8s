import logging

from src.core.setup import loggers


LOGGER_NAME = "app"


loggers.setup(LOGGER_NAME)


logger = logging.getLogger(LOGGER_NAME)
