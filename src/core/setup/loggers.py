from logging.config import dictConfig

from src.core.config.envs import LOG_LEVEL


def setup(name: str):
    dictConfig(
        {
            "version": 1,
            "formatters": {
                "default": {"format": "%(asctime)s [%(levelname)s] %(name)s: %(message)s"},
            },
            "handlers": {
                "default": {
                    "level": LOG_LEVEL,
                    "formatter": "default",
                    "class": "logging.StreamHandler",
                    "stream": "ext://sys.stdout",
                },
            },
            "loggers": {
                name: {"handlers": ["default"], "level": "INFO", "propagate": True},
            },
        }
    )
