provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
  credentials = "${var.service_account_key}"
}

terraform {
  backend "gcs" {
    bucket = "ezetina_weather_app"
    prefix = "terraform/state"
  }
}
