FROM python:3.9 as poetry

ENV POETRY_HOME="/opt/poetry" \
    PATH="/opt/poetry/bin:${PATH}"

RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /py
COPY poetry.lock pyproject.toml ./

RUN poetry export > /requirements.txt
RUN poetry export --only dev > /requirements.dev.txt

FROM python:3.9-alpine3.13
LABEL maintainer="oleksandr.hiliazov"

ENV PYTHONUNBUFFERED=1

COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN --mount=from=poetry,target=/tmp \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV == "true" ]; then \
      /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:${PATH}"

USER django-user
