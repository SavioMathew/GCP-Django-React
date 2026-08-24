"""
Onboarding API View
----------------------
Exposes StudentOnboardingSerializer as a live POST endpoint so DCYN
validation can be demonstrated against real HTTP requests, not just
unit tests.

Author: Savio Mathew
Contact: <your email / phone here>
"""

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .serializers import StudentOnboardingSerializer


@api_view(["POST"])
def submit_onboarding(request):
    serializer = StudentOnboardingSerializer(data=request.data)
    if serializer.is_valid():
        return Response(
            {"status": "ACCEPTED", "validated_data": serializer.validated_data},
            status=status.HTTP_201_CREATED,
        )
    return Response(
        {"status": "REJECTED", "errors": serializer.errors},
        status=status.HTTP_400_BAD_REQUEST,
    )
