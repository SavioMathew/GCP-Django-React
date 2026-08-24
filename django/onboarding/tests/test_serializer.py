"""
Tests for StudentOnboardingSerializer / DCYN validation.
-----------------------------------------------------------
Demonstrates fail-closed behavior at the data layer: valid payloads
pass cleanly, and each deliberately broken payload is rejected with
no partial acceptance or human review required.

Author: Savio Mathew
Contact: <your email / phone here>
"""

from django.test import SimpleTestCase
from onboarding.serializers import StudentOnboardingSerializer


VALID_PAYLOAD = {
    "student_full_name": "Aarav Sharma",
    "date_of_birth": "2015-06-12",
    "guardian_full_name": "Priya Sharma",
    "guardian_contact_number": "9876543210",
    "guardian_email": "priya.sharma@example.com",
    "learning_difficulty_category": "DYSLEXIA",
    "consent_given": True,
}


class StudentOnboardingSerializerTests(SimpleTestCase):

    def test_valid_payload_passes(self):
        serializer = StudentOnboardingSerializer(data=VALID_PAYLOAD)
        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.errors, {})

    def test_invalid_name_with_digits_fails(self):
        payload = {**VALID_PAYLOAD, "student_full_name": "Aarav123"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("student_full_name", serializer.errors)

    def test_future_date_of_birth_fails(self):
        payload = {**VALID_PAYLOAD, "date_of_birth": "2099-01-01"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("date_of_birth", serializer.errors)

    def test_malformed_date_of_birth_fails(self):
        payload = {**VALID_PAYLOAD, "date_of_birth": "12-06-2015"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("date_of_birth", serializer.errors)

    def test_invalid_guardian_phone_fails(self):
        payload = {**VALID_PAYLOAD, "guardian_contact_number": "12345"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("guardian_contact_number", serializer.errors)

    def test_invalid_guardian_email_fails(self):
        payload = {**VALID_PAYLOAD, "guardian_email": "not-an-email"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("guardian_email", serializer.errors)

    def test_unrecognized_learning_category_fails(self):
        payload = {**VALID_PAYLOAD, "learning_difficulty_category": "UNKNOWN_TYPE"}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("learning_difficulty_category", serializer.errors)

    def test_missing_explicit_consent_fails(self):
        payload = {**VALID_PAYLOAD, "consent_given": False}
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("consent_given", serializer.errors)

    def test_out_of_age_range_child_fails(self):
        payload = {**VALID_PAYLOAD, "date_of_birth": "2000-01-01"}  # too old
        serializer = StudentOnboardingSerializer(data=payload)
        self.assertFalse(serializer.is_valid())
        self.assertIn("date_of_birth", serializer.errors)
