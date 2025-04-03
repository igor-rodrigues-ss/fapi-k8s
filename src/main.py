from fastapi import FastAPI

from src.core.config.envs import EXAMPLE

from src.core.setup import databases, routes

from src.tasks.heavy_processing import heavy_processing


app = FastAPI()


routes.setup(app)

databases.setup()


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
