"""
Tests for models.
"""

from django.contrib.auth import get_user_model
from django.test import TestCase


class ModelTests(TestCase):
    """Test models."""

    def test_create_user_with_email_successful(self):
        email = "test@example.com"
        password = "testpass123"
        user = get_user_model().objects.create_user(
            email=email,
            password=password,
        )
        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))

    def test_new_user_email_normalized(self):
        sample_emails = [
            ("test1@EXAMPLE.com", "test1@example.com"),
            ("Test2@example.com", "Test2@example.com"),
            ("TEST3@EXAMPLE.COM", "TEST3@example.com"),
            ("test4@example.COM", "test4@example.com"),
        ]
        for email, expected in sample_emails:
            user = get_user_model().objects.create_user(
                email=email,
                password="password",
            )
            self.assertEqual(user.email, expected)

    def test_new_user_without_email_raises_error(self):
        sample_emails = ["", None]
        for email in sample_emails:
            with self.assertRaises(ValueError):
                get_user_model().objects.create_user(
                    email=email,
                    password="testpass123",
                )

    def test_create_new_superuser(self):
        user = get_user_model().objects.create_superuser(
            email="test@example.com",
            password="testpass123",
        )
        self.assertTrue(user.is_superuser)
        self.assertTrue(user.is_staff)
