import os
from fastapi import FastAPI

from settings import EXAMPLE
from celery_worker import heavy_processing


app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello API"}


@app.get("/secret")
async def secret():
    return {"example": EXAMPLE}


@app.get("/processing")
async def processing():
    result = heavy_processing.delay()

    return {"task_id": result.id}