# 1. Cloud Run Service (v2)
resource "google_cloud_run_v2_service" "container" {
  name     = "cr-portfolio-${var.environment}"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    containers {
      image = "nginx:latest"

      # Nginx defaults to port 80, so we must tell Cloud Run to route traffic there
      ports {
        container_port = 80
      }
    }
  }
}

# 2. Public Invoker Access (Make the website publicly accessible)
resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = google_cloud_run_v2_service.container.project
  location = google_cloud_run_v2_service.container.location
  name     = google_cloud_run_v2_service.container.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# 3. Output the live URL
output "cloud_run_url" {
  value       = google_cloud_run_v2_service.container.uri
  description = "The live HTTPS URL of the Cloud Run container"
}
