#!/usr/bin/env just --justfile

help:
    just --list

install:
    poetry install --with dev --sync --no-interaction --no-root
    poetry run pre-commit install

requirements:
    poetry lock --no-update
    poetry export --without-hashes --only main > requirements.txt
    poetry export --without-hashes --only psycopg2 > requirements.psycopg2.txt
    poetry export --without-hashes --only dev > requirements.dev.txt

lint:
    poetry run pre-commit run --all

up: requirements
    docker-compose up --build

run *command:
    docker-compose run --rm app sh -c "{{command}}"

test:
    just run python manage.py test
