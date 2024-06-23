"""
Django command to wait until database is available.
"""

import time

from django.core.management.base import BaseCommand
from django.db.utils import OperationalError
from psycopg2 import OperationalError as Psycopg2OperationalError


class Command(BaseCommand):
    def handle(self, *args, **options):
        """Entrypoint for the management command."""
        self.stdout.write("Waiting for database...")
        while True:
            try:
                self.check(databases=["default"])
                break
            except (Psycopg2OperationalError, OperationalError):
                self.stdout.write(
                    self.style.WARNING(
                        "Database not available, waiting 1 second..."
                    )
                )
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS("Database available!"))
