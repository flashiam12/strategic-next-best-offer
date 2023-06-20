FROM python:3.9.17-slim-bullseye

WORKDIR /apps

COPY ./apps/ .

RUN apt-get update && apt-get install libpq-dev python3-dev gcc -y

RUN python3 -m pip install -r requirements.txt

