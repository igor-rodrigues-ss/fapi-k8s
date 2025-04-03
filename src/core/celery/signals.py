import os

from celery import signals


HOSTNAME = os.environ.get("HOSTNAME", "")


@signals.worker_ready.connect
def worker_ready(**kwargs):
    if HOSTNAME and HOSTNAME.endswith("-0"):
        print(f"Worker {HOSTNAME} ready to process orphan tasks")
