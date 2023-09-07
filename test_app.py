import unittest
from app import app


class FlaskAppTestCase(unittest.TestCase):

    def setUp(self):
        self.app = app.test_client()

    def test_valid_city(self):
        response = self.app.post('/', data={'city': 'Denver'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Denver', response.data)

    def test_invalid_city(self):
        response = self.app.post('/', data={'city': 'InvalidCity'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Invalid city. Please enter a valid US city.', response.data)

    def test_empty_city(self):
        response = self.app.post('/', data={'city': ''})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Invalid city. Please enter a valid US city.', response.data)

    def test_valid_city_with_spaces(self):
        response = self.app.post('/', data={'city': 'New York'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'New York', response.data)

    def test_city_with_special_characters(self):
        response = self.app.post('/', data={'city': 'San Francisco!'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Invalid city. Please enter a valid US city.', response.data)


if __name__ == '__main__':
    unittest.main()
