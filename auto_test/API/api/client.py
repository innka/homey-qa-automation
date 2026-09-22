class ApiClient:
    def __init__(self, session, base_url, headers):
        self.session = session
        self.base_url = base_url
        self.headers = headers
        self.ajax_url = f"{self.base_url}/wp-admin/admin-ajax.php"

    def post(self, data):
        response = self.session.post(self.ajax_url, data=data, headers=self.headers)
        return response