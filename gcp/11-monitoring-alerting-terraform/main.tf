variable "project_id" {}
variable "environment" {}

provider "google" {
  project = var.project_id
  region = "us-central1"
}

# Notification Channel (Equivalent to Azure Action Group)
resource "google_monitoring_notification_channel" "email" {
  display_name = "Portfolio Alerts ${var.environment}"
  type = "email"
  labels = { email_address = "akinbidamilola074@gmail.com" }
}

# Alert Policy (Equivalent to Azure Alert Rule)
resource "google_monitoring_alert_policy" "cpu_alert" {
  display_name = "High CPU Alert ${var.environment}"
  combiner = "OR"

  conditions {
    display_name = "CPU utilization > 80%"
    condition_threshold {
        # KQL equivalent: querying for Compute Engine CPU metrics
        filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
        duration = "300s" # Check over a 5-minute window
        comparison = "COMPARISON_GT"
        threshold_value = 0.8

        aggregations {
          alignment_period = "60s"
          per_series_aligner = "ALIGN_MEAN"
        }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]
}