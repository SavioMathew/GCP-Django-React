"""
Student Onboarding Model
----------------------------
Persists validated onboarding submissions. Records are only ever
created via StudentOnboardingModelSerializer, which enforces DCYN
validation before .save() is called — so every row in this table is
guaranteed to have passed all binary Yes/No checks.

Author: Savio Mathew
Contact: <your email / phone here>
"""

from django.db import models


class StudentOnboarding(models.Model):
    student_full_name = models.CharField(max_length=100)
    date_of_birth = models.CharField(max_length=10)
    guardian_full_name = models.CharField(max_length=100)
    guardian_contact_number = models.CharField(max_length=13)
    guardian_email = models.EmailField(max_length=254)
    learning_difficulty_category = models.CharField(max_length=30)
    consent_given = models.BooleanField()
    submitted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.student_full_name} ({self.submitted_at:%Y-%m-%d %H:%M})"
