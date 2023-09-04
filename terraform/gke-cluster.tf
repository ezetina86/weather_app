resource "google_container_cluster" "weather-cluster" {
  name     = "weather-cluster"
  location = var.region

  # Configure the node pool
  node_pool {
    name       = "default-pool"

    node_config {
      machine_type = var.machine_type
      preemptible  = false
      disk_size_gb = 10
      disk_type    = "pd-standard"
      image_type   = "COS"
    }

  }

  # Cluster autoscaling settings
  node_locations = ["us-south1-a", "us-south1-b", "us-south1-c"]

  # Optional: Enable HTTP load balancing (if needed)
  addons_config {
    http_load_balancing {
      disabled = false
    }
  }
}

# Configure Kubernetes Deployment
resource "kubernetes_deployment" "weather-app-deployment" {
  metadata {
    name = "weather-app-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        container {
          name  = "weather-app"
          image = "us-south1-docker.pkg.dev/ezetina-gcp-project/weather-docker-repo/weather-app"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
