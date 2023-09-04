from flask import Flask, request, render_template
import os
import requests
import json
from google.cloud import secretmanager

#  Global variables
project_id = "ezetina-gcp-project"
secret_id = "WEATHER_API_KEY"
version_id = "latest"

# Load the JSON file into a list of dictionaries
with open('us-cities-demographics.json', 'r') as json_file:
    us_cities_data = json.load(json_file)


# Function to filter JSON data
def filter_json_data(json_data):
    filtered_data = []
    for item in json_data:
        filtered_item = {"city": item["city"]}
        filtered_data.append(filtered_item)
    return filtered_data


# Function to retrieve the API key from Secret Manager
def get_secret(project, secret, version):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project}/secrets/{secret_id}/versions/{version_id}"
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")


# Filter the JSON data to keep only the "city" field
us_cities_data = filter_json_data(us_cities_data)

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def get_weather():
    error_message = None
    city = ''

    if request.method == 'POST':
        city = request.form['city']
        if is_valid_us_city(city):
            weather_data = get_weather_data(city)
            return render_template('weather.html', weather_data=weather_data)
        else:
            error_message = "Invalid city. Please enter a valid US city."

    return render_template('index.html', error_message=error_message, city=city)


def is_valid_us_city(city):
    # Check if the entered city is in the list of dictionaries
    return any(item["city"].lower() == city.lower() for item in us_cities_data)


def get_weather_data(city):
    api_key = get_secret(project_id, secret_id, version_id)
    base_url = 'https://api.weatherapi.com/v1/current.json'
    params = {'key': api_key, 'q': city}
    response = requests.get(base_url, params=params)
    data = response.json()
    return data


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
