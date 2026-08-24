"""
DCYN Library — Deconstruct-to-Yes/No Validation
-------------------------------------------------
Every function here resolves a single raw input value to a strict
boolean outcome: True (valid) or False (invalid). No partial results,
no warnings, no human judgment calls — every field is either accepted
or rejected, matching HabotConnect's fail-closed / Poka-Yoke standard.

Author: Savio Mathew
Contact: <your email / phone here>
"""

import re
from datetime import date, datetime


def is_valid_full_name(value: str) -> bool:
    """Accepts letters, spaces, hyphens, apostrophes. 2-100 chars."""
    if not isinstance(value, str):
        return False
    value = value.strip()
    if not (2 <= len(value) <= 100):
        return False
    return bool(re.fullmatch(r"[A-Za-z\-\' ]+", value))


def is_valid_date_of_birth(value: str) -> bool:
    """Expects YYYY-MM-DD. Must be a real past date, child aged 2-18."""
    if not isinstance(value, str):
        return False
    try:
        dob = datetime.strptime(value, "%Y-%m-%d").date()
    except ValueError:
        return False
    if dob >= date.today():
        return False
    age_years = (date.today() - dob).days / 365.25
    return 2 <= age_years <= 18


def is_valid_guardian_contact_number(value: str) -> bool:
    """Expects a 10-digit Indian mobile number, optionally +91 prefixed."""
    if not isinstance(value, str):
        return False
    value = value.strip()
    return bool(re.fullmatch(r"(\+91)?[6-9]\d{9}", value))


def is_valid_guardian_email(value: str) -> bool:
    """Basic strict email shape check. No free-text judgment allowed."""
    if not isinstance(value, str):
        return False
    return bool(re.fullmatch(r"[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}", value.strip()))


LEARNING_DIFFICULTY_CATEGORIES = {
    "DYSLEXIA",
    "DYSGRAPHIA",
    "DYSCALCULIA",
    "ADHD",
    "AUTISM_SPECTRUM",
    "OTHER",
}


def is_valid_learning_difficulty_category(value: str) -> bool:
    """Must be one of a fixed, closed set of categories. No free text."""
    if not isinstance(value, str):
        return False
    return value.strip().upper() in LEARNING_DIFFICULTY_CATEGORIES


def is_valid_consent(value) -> bool:
    """Consent must be an explicit boolean True. No implicit truthy values."""
    return value is True
