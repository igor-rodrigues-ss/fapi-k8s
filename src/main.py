from fastapi import FastAPI

from src.core.setup import routes


app = FastAPI()


routes.setup(app)
