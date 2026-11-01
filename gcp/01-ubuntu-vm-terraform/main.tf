provider "google" {
  project = "damis-project-01"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-portfolio-iac"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_linux_vm" {
  name          = "subnet-linux-vm"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}