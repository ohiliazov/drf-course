FROM python:3.9-alpine3.13
LABEL maintainer="oleksandr.hiliazov"

ENV PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=100
EXPOSE 8000

RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user

RUN pip install --upgrade pip

RUN --mount=type=bind,source=requirements.psycopg2.txt,target=/tmp/requirements.psycopg2.txt \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    pip install --no-cache-dir -r /tmp/requirements.psycopg2.txt && \
    apk del .tmp-build-deps

RUN --mount=type=bind,source=requirements.main.txt,target=/tmp/requirements.main.txt \
    pip install --no-cache-dir -r /tmp/requirements.main.txt

ARG DEV=false
RUN --mount=type=bind,source=requirements.dev.txt,target=/tmp/requirements.dev.txt \
    if [ $DEV == "true" ]; then \
      pip install --no-cache-dir -r /tmp/requirements.dev.txt; \
    fi

COPY ./app /app
WORKDIR /app

USER django-user
