#!/usr/bin/env just --justfile

help:
    just --list

# install poetry dependencies and pre-commit hook
install:
    poetry install --with dev --sync --no-interaction --no-root
    poetry run pre-commit install

poetry-export group:
    poetry export --without-hashes --only {{ group }} > requirements.{{ group }}.txt

requirements:
    poetry lock --no-update
    for group in main psycopg2 dev; do just poetry-export ${group}; done

lint:
    poetry run pre-commit run --all

format:
    poetry run ruff format
    poetry run ruff check --fix

up:
    docker compose up --build

down:
    docker compose down

run *command:
    docker compose run --rm app sh -c "{{command}}"

manage *command:
    just run python manage.py {{ command }}

test:
    just manage test

makemigrations:
    just manage makemigrations

migrate:
    just manage wait_for_db
    just manage migrate
