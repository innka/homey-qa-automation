#test_reservation_api.py
# Reservation API tests
# These tests verify booking validation scenarios for a property listing.
# Each test sends a request to the backend and checks the API response structure and message.

# def test_api_01_successful_add_reservation(reservation_api, validate_base_response):
#     # Test case: valid reservation request should be accepted by the API
#     response = reservation_api.add_reservation(
#         check_in_date="2026-11-14",
#         check_out_date="2026-11-15",
#         guests="2",
#         listing_id="8260", )

#     # Basic response validation common for all API calls
#     response_data = validate_base_response(response)

#     # The booking should succeed and return the expected confirmation message
#     assert response_data["success"] is True, response.text
#     assert "Demande de réservation envoyée" in response_data["message"], response.text

def test_api_02_unavailable_dates(reservation_api, validate_base_response):
    # Test case: dates selected are already unavailable for the listing
    response = reservation_api.add_reservation(
        check_in_date="2026-11-12",
        check_out_date="2026-11-13",
        guests="2",
        listing_id="8260",)

    # Validate the base response shape and status
    response_data = validate_base_response(response)

    # API should reject the reservation and return the expected unavailable-dates message
    assert response_data["success"] is False, response.text
    assert "Vos dates ne sont pas disponibles" in response_data["message"], response.text

# Check-in date is after check-out date
def test_api_03_invalid_dates(reservation_api, validate_base_response):
    # Test case: departure date is before arrival date
    response = reservation_api.check_booking_availability(
        check_in_date="2026-11-22",
        check_out_date="2026-11-21",
        guests="2",
        listing_id="8260",)

    # Validate the base response
    response_data = validate_base_response(response)

    # API should reject invalid date ordering
    assert response_data["success"] is False, response.text
    assert "La date de d\u00e9part doit \u00eatre sup\u00e9rieure \u00e0 la date d&#039;arriv\u00e9e" in response_data["message"], response.text

# Check-in date equals check-out date
def test_api_04_invalid_dates(reservation_api, validate_base_response):
    # Test case: arrival and departure dates are the same, which is invalid
    response = reservation_api.check_booking_availability(
        check_in_date="2026-11-22",
        check_out_date="2026-11-22",
        guests="2",
        listing_id="8260",)

    # Validate the base response
    response_data = validate_base_response(response)

    # API should reject zero-night booking
    assert response_data["success"] is False, response.text
    assert "La date de d\u00e9part doit \u00eatre sup\u00e9rieure \u00e0 la date d&#039;arriv\u00e9e" in response_data["message"], response.text

def test_api_05_booking_cost_page(reservation_api):
    # Placeholder for future test:
    # verify that total cost is calculated correctly for a valid reservation.
    pass

def test_api_06_invalid_guests(reservation_api, validate_base_response):
    # Test case: guest count is zero, which is not allowed
    response = reservation_api.add_reservation(
        check_in_date="2026-11-22",
        check_out_date="2026-11-23",
        guests="0",
        listing_id="8260",)

    # Validate the base response
    response_data = validate_base_response(response)

    # API should reject the reservation due to invalid guest count
    assert response_data["success"] is False, response.text
    assert "Veuillez choisir des voyageurs" in response_data["message"], response.text

def test_api_07_missing_check_out_date(reservation_api, validate_base_response):
    # Test case: check-out date is empty, so the booking is incomplete
    response = reservation_api.add_reservation(
        check_in_date="2026-11-22",
        check_out_date="",
        guests="2",
        listing_id="8260",)

    # Validate the base response
    response_data = validate_base_response(response)

    # API should return an error because the date information is incomplete
    assert response_data["success"] is False, response.text
    assert "Vos dates ne sont pas disponibles" in response_data["message"], response.text

# Test case: invalid listing ID must be rejected by the API
def test_api_08_invalid_listing_id(reservation_api, validate_base_response):
    # Test case: listing ID does not exist, so the request should be rejected
    response = reservation_api.add_reservation(
        check_in_date="2026-11-20",
        check_out_date="2026-11-21",
        guests="2",
        listing_id="00000",)

    # Validate the base response
    response_data = validate_base_response(response)

    # API should reject the request because the listing is invalid
    assert response_data["success"] is False, response.text
    assert "Vos dates ne sont pas disponibles" in response_data["message"], response.text