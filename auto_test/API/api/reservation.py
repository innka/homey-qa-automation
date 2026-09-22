#reservation.py
class ReservationAPI:
    # AJAX action used to create a reservation request
    ADD_RESERVATION_ACTION = "homey_add_reservation"

    def __init__(self, client):
        # HTTP client used for making API requests
        self.client = client

    def add_reservation(self, check_in_date, check_out_date, guests, listing_id):
        # Build the request payload required by the reservation endpoint
        reservation_data = {
            "action": self.ADD_RESERVATION_ACTION,
            "check_in_date": check_in_date,
            "check_out_date": check_out_date,
            "guests": guests,
            "listing_id": listing_id,
        }

        # Send the reservation request to the backend
        response = self.client.post(data=reservation_data)
        return response

    def check_booking_availability(self, check_in_date, check_out_date, guests, listing_id):
        # Build the payload for checking whether selected dates are available
        availability_data = {
            "action": "check_booking_availability_on_date_change",
            "check_in_date": check_in_date,
            "check_out_date": check_out_date,
            "guests": guests,
            "listing_id": listing_id,
        }

        # Send the availability check request
        response = self.client.post(data=availability_data)
        return response