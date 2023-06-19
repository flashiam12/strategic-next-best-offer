FROM python:3.9-alpine3.18

WORKDIR /apps

COPY ./apps/ .

RUN python3 -m pip install -r requirements.txt

