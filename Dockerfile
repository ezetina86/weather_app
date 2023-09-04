# Use the official Python image as a parent image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install application dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install production dependencies.
RUN pip install Flask gunicorn

# Copy the application code into the container
COPY . .

# Expose port 80 for the Flask app
EXPOSE 8080

# Define the command to run your Flask app
CMD exec gunicorn --bind :8080 --workers 1 --threads 8 app:app
