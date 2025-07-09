from fastapi import FastAPI

from src.core.setup import routes, loggers


app = FastAPI()


loggers.setup()
routes.setup(app)
