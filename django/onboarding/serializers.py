"""
Student Onboarding Serializer
-------------------------------
Enforces exact field validation limits using the DCYN library, so
schema validation is deterministic and requires no human review before
data reaches Pub/Sub / BigQuery downstream.

Author: Savio Mathew
Contact: <your email / phone here>
"""

from rest_framework import serializers
from . import dcyn


class StudentOnboardingSerializer(serializers.Serializer):
    student_full_name = serializers.CharField(max_length=100)
    date_of_birth = serializers.CharField(max_length=10)
    guardian_full_name = serializers.CharField(max_length=100)
    guardian_contact_number = serializers.CharField(max_length=13)
    guardian_email = serializers.EmailField(max_length=254)
    learning_difficulty_category = serializers.ChoiceField(
        choices=sorted(dcyn.LEARNING_DIFFICULTY_CATEGORIES)
    )
    consent_given = serializers.BooleanField()

    def validate_student_full_name(self, value):
        if not dcyn.is_valid_full_name(value):
            raise serializers.ValidationError(
                "Student full name must be 2-100 characters, letters only."
            )
        return value

    def validate_date_of_birth(self, value):
        if not dcyn.is_valid_date_of_birth(value):
            raise serializers.ValidationError(
                "Date of birth must be YYYY-MM-DD, and child must be aged 2-18."
            )
        return value

    def validate_guardian_full_name(self, value):
        if not dcyn.is_valid_full_name(value):
            raise serializers.ValidationError(
                "Guardian full name must be 2-100 characters, letters only."
            )
        return value

    def validate_guardian_contact_number(self, value):
        if not dcyn.is_valid_guardian_contact_number(value):
            raise serializers.ValidationError(
                "Guardian contact number must be a valid 10-digit Indian mobile number."
            )
        return value

    def validate_guardian_email(self, value):
        if not dcyn.is_valid_guardian_email(value):
            raise serializers.ValidationError("Guardian email is not a valid email address.")
        return value

    def validate_learning_difficulty_category(self, value):
        if not dcyn.is_valid_learning_difficulty_category(value):
            raise serializers.ValidationError(
                f"Category must be one of: {sorted(dcyn.LEARNING_DIFFICULTY_CATEGORIES)}"
            )
        return value

    def validate_consent_given(self, value):
        if not dcyn.is_valid_consent(value):
            raise serializers.ValidationError("Consent must be explicitly True.")
        return value
