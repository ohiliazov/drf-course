#!/usr/bin/env just --justfile

help:
    just --list

# install poetry dependencies and pre-commit hook
install:
    poetry install --with dev --sync --no-interaction --no-root
    poetry run pre-commit install

requirements:
    poetry lock --no-update
    poetry export --without-hashes --only main > requirements.main.txt
    poetry export --without-hashes --only psycopg2 > requirements.psycopg2.txt
    poetry export --without-hashes --only dev > requirements.dev.txt

lint:
    poetry run pre-commit run --all

format:
    poetry run ruff format
    poetry run ruff check

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
