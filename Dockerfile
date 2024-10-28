FROM python:3.13-bookworm

WORKDIR /app

COPY /app /app
COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir --upgrade -r requirements.txt

EXPOSE 8000

CMD ["fastapi", "run", "main.py", "--root-path", "/", "--port", "8000"]