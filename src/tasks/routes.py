from fastapi import APIRouter

from src.tasks import controllers


router = APIRouter()


router.get("/processing")(controllers.processing)
