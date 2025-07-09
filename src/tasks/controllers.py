from src.tasks.celery_tasks import heavy_processing


async def processing():
    result = heavy_processing.task.delay()

    return {"task_id": result.id}
