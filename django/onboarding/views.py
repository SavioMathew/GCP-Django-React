
"""
Onboarding API View
----------------------
Exposes StudentOnboardingModelSerializer as a live POST endpoint so DCYN
validation can be demonstrated against real HTTP requests, not just
unit tests. Valid submissions are persisted to the database.

Author: Savio Mathew
Contact: <your email / phone here>
"""

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .serializers import StudentOnboardingModelSerializer


@api_view(["POST"])
def submit_onboarding(request):
    serializer = StudentOnboardingModelSerializer(data=request.data)
    if serializer.is_valid():
        instance = serializer.save()
        return Response(
            {"status": "ACCEPTED", "id": instance.id, "validated_data": serializer.data},
            status=status.HTTP_201_CREATED,
        )
    return Response(
        {"status": "REJECTED", "errors": serializer.errors},
        status=status.HTTP_400_BAD_REQUEST,
    )

