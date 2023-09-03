# Weather App

This is a simple Flask web application that allows users to check the weather for a city in the USA. It uses the WeatherAPI to provide weather information based on user input.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features

- Users can enter the name of a city in the USA.
- The app validates whether the city is a valid city in the USA.
- If the city is valid, it retrieves and displays weather information.
- If the city is not valid, it displays an error message and clears the input field.
- The app uses a separate configuration file to store the WeatherAPI key for security.

## Setup

### Prerequisites

Before running this application, you need to have the following installed:

- Python 3
- Flask
- Requests (for making API requests)

### Installation

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/weather-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd weather-app
   ```
3. Create a virtual environment (optional but recommended):
   ``` bash
   python -m venv venv
   ```
4. Activate the virtual environment:
   ```bash
   source venv/bin/activate
   ```
5. Install the required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

### Usage

1. Run the Flask app:
   ```bash
   python app.py

   ```
2. Open a web browser and navigate to http://localhost:5000/ to access the application.
3. Enter the name of a city in the USA into the input field and click the "Get Weather" button.
4. If the city is valid, you will see weather information displayed on the page.
5. If the city is not valid, you will see an error message, and the input field will be cleared.

### UsaContributingge

Contributions are welcome! If you would like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test them.
4. Commit your changes with descriptive commit messages.
5. Push your changes to your fork.
6. Submit a pull request to the main repository.


