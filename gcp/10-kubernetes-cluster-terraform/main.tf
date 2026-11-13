variable "project_id" {}
variable "environment" {}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

resource "google_container_cluster" "primary" {
  name     = "gke-portfolio-${var.environment}"
  location = "us-central1-a"

  # we remove the default node pool to manage our own custom, cost-effective pool
  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "e2-medium" # cost-effective node size for GCP
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}