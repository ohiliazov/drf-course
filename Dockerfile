FROM python:3.9-alpine3.13
LABEL maintainer="oleksandr.hiliazov"

ENV PYTHONUNBUFFERED=1
EXPOSE 8000

RUN adduser \
        --disabled-password \
        --no-create-home \
        django-user

COPY requirements.txt requirements.psycopg2.txt requirements.dev.txt /tmp/

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install --no-cache-dir -r /tmp/requirements.psycopg2.txt && \
    apk del .tmp-build-deps

RUN /py/bin/pip install --no-cache-dir -r /tmp/requirements.txt && \
    if [ $DEV == "true" ]; then \
      /py/bin/pip install --no-cache-dir -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp

COPY ./app /app
WORKDIR /app

ENV PATH="/py/bin:${PATH}"

USER django-user
