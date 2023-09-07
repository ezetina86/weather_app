# Use the official Python image as a parent image
FROM ubuntu:latest

# Update the package list and install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip graphviz

# Set the working directory inside the container
WORKDIR /app

# Copy the application code into the container
COPY . .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create diagrams
RUN python3 diagram.py

# Run unit tests
RUN python3 test_app.py

# Define the command to run your Flask app
CMD exec gunicorn --bind :8080 --workers 1 --threads 8 app:app
