from django.urls import path
from .views import submit_onboarding

urlpatterns = [
    path("onboarding/submit/", submit_onboarding, name="submit-onboarding"),
]
