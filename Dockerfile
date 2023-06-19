FROM python:3.9.17-slim-bullseye

WORKDIR /apps

COPY ./apps/ .

RUN python3 -m pip install -r requirements.txt

