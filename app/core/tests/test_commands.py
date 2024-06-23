from unittest.mock import MagicMock, patch

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase
from psycopg2 import OperationalError as Psycopg2OperationalError


@patch("core.management.commands.wait_for_db.Command.check")
class CommandTests(SimpleTestCase):
    """Test the command functions."""

    def test_wait_for_db_ready(self, patched_check: MagicMock) -> None:
        """Test waiting for db when db is available."""
        patched_check.return_value = True
        call_command("wait_for_db")
        patched_check.assert_called_once_with(databases=["default"])

    @patch("time.sleep")
    def test_wait_for_db_delay(
        self,
        _: MagicMock,
        patched_check: MagicMock,
    ) -> None:
        """Test waiting for db when db is not available."""
        patched_check.side_effect = [
            Psycopg2OperationalError,
            Psycopg2OperationalError,
            OperationalError,
            OperationalError,
            OperationalError,
            True,
        ]

        call_command("wait_for_db")

        self.assertEqual(patched_check.call_count, 6)

        patched_check.assert_called_with(databases=["default"])
