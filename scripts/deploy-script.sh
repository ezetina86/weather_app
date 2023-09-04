#!/bin/bash

# Step 0: Enable Necessary Google Cloud APIs
echo "Step 0: Enable Necessary Google Cloud APIs"
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com


# Step 1: Authenticate and Set Up Google Cloud SDK
echo "Step 1: Authenticate and Set Up Google Cloud SDK"
#gcloud auth login

# Set  Google Cloud project ID (replace <project_id> with your actual project ID)
PROJECT_ID="ezetina-gcp-project"

# Set the region and bucket name
REGION="us-south1"
BUCKET_NAME="ezetina_weather_app"

# Set terraform SA name
SERVICE_ACCOUNT_NAME="terraform-editor-sa"
KEY_FILE="$SERVICE_ACCOUNT_NAME-key.json"

# Set your desired Docker image name and tag
IMAGE_NAME="weather-app"
IMAGE_TAG="latest"

# Step 2: Build and Tag Docker Image
#echo "Step 2: Build and Tag Docker Image"
#docker build -t $IMAGE_NAME .
#docker tag $IMAGE_NAME gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG

# Step 2: Send image to Artifact Registry
echo "Step 2: Send image to Artifact Registry"
gcloud artifacts repositories create weather-docker-repo --repository-format=docker \
--location=us-south1 --description="Weather repository"
gcloud artifacts repositories list
gcloud auth configure-docker us-south1-docker.pkg.dev
docker build --platform=linux/amd64 -t $IMAGE_NAME:$IMAGE_TAG .
docker tag $IMAGE_NAME \
us-south1-docker.pkg.dev/$PROJECT_ID/weather-docker-repo/$IMAGE_NAME:$IMAGE_TAG

# Step 3: Push Docker Image to Google Artifact Registry
echo "Step 3: Push Docker Image to Google Artifact Registry"
docker push us-south1-docker.pkg.dev/$PROJECT_ID/weather-docker-repo/$IMAGE_NAME:$IMAGE_TAG
echo "Docker image $IMAGE_NAME:$IMAGE_TAG has been pushed to Artifact Registry."

# Step 4: Check if the Google Cloud Storage Bucket Exists
echo "Step 4: Check if the Google Cloud Storage Bucket Exists"

if gsutil ls -b gs://$BUCKET_NAME >/dev/null 2>&1; then
  echo "Bucket $BUCKET_NAME already exists."
else
# Step 5: Create a Google Cloud Storage Bucket
  echo "Bucket $BUCKET_NAME does not exist. Creating..."
  gsutil mb -l $REGION gs://$BUCKET_NAME
  echo "Bucket $BUCKET_NAME in region $REGION has been created."
fi

# Step 6: Check if the Terraform Service Account exists Exists

# Check if the service account already exists
EXISTING_SERVICE_ACCOUNT=$(gcloud iam service-accounts list --project=$PROJECT_ID --filter="email~$SERVICE_ACCOUNT_NAME" --format="value(email)")

if [ -n "$EXISTING_SERVICE_ACCOUNT" ]; then
  echo "Service account '$SERVICE_ACCOUNT_NAME' already exists: $EXISTING_SERVICE_ACCOUNT"
else
# Create the service account
  gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME --display-name "Terraform Editor Service Account"
# Assign the "Editor" role to the service account
  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/editor"
# Generate a JSON key file for the service account
  gcloud iam service-accounts keys create $KEY_FILE --iam-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

# Output the key file path
echo "Service account key file created: $KEY_FILE"
fi

