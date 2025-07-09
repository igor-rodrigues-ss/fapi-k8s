from fastapi import FastAPI

from src.tasks.routes import router as tasks_routes


def setup(app: FastAPI):
    app.include_router(tasks_routes, prefix="/tasks")
