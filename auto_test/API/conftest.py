# conftest.py
import os

import pytest
import requests
from re import search
from datetime import date, timedelta

from api.client import ApiClient
from api.reservation import ReservationAPI

# Base URL of the application under test
BASE_URL = "http://livraison3.testacademy.fr"

# AJAX endpoint used by the site for login and reservation actions
AJAX_URL = f"{BASE_URL}/wp-admin/admin-ajax.php"

# Common headers required for AJAX requests
HEADERS = {
    "X-Requested-With": "XMLHttpRequest",
    "Origin": BASE_URL,
    "Referer": f"{BASE_URL}/",
}

@pytest.fixture
def validate_base_response():
    # Shared validator for API responses.
    # It checks the common response structure used across endpoints.
    def _validate(response):
        response_data = response.json()

        # Response must return HTTP 200 OK
        assert response.status_code == 200
        # Response body should contain the standard success/message fields
        assert "message" in response_data
        assert "success" in response_data
        # Success field must be boolean, message must be a string
        assert isinstance(response_data["success"], bool)
        assert isinstance(response_data["message"], str)

        return response_data

    return _validate

@pytest.fixture
def future_booking_dates():
    # Provide a pair of check-in and check-out dates in the future for testing
    #build_number is used to ensure that the dates are always in the future, even if tests are run multiple times
    #build_number = int(os.getenv("BUILD_NUMBER", "0"))

    check_in = date.today() + timedelta(days=30)# + build_number)
    check_out = check_in + timedelta(days=1)

    return {
        "check_in_date": check_in.isoformat(),
        "check_out_date": check_out.isoformat(),
    }

@pytest.fixture
def authenticated_session():
    # Create a persistent session for all requests.
    # This allows login state to be reused across multiple API calls.
    session = requests.Session()

    # Open the homepage to get the login security token
    page = session.get(BASE_URL)
    page.raise_for_status()

    # Extract the hidden security token required by the login form
    match = search(
        r'name=["\']homey_login_security["\'][^>]*value=["\']([^"\']+)',
        page.text,
    )
    assert match is not None, "Security token not found on the page"
    token = match.group(1)

    # Prepare the login payload for the AJAX login endpoint
    login_data = {
        "username": "robot",
        "password": "robot",
        "homey_login_security": token,
        "_wp_http_referer": "/",
        "action": "homey_login",
    }

    # Authenticate before sending reservation-related requests
    login_response = session.post(AJAX_URL, data=login_data, headers=HEADERS)
    login_response_data = login_response.json()

    # Verify that login succeeded
    assert login_response.status_code == 200
    assert login_response_data.get("success") is True

    return session

@pytest.fixture
def api_client(authenticated_session):
    # Create a reusable API client bound to the authenticated session.
    api_client = ApiClient(
        session=authenticated_session,
        base_url=BASE_URL,
        headers=HEADERS,
    )
    return api_client

@pytest.fixture
def reservation_api(api_client):
    # Expose reservation-specific API methods to tests.
    return ReservationAPI(api_client)