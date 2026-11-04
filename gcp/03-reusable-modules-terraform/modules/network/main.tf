variable "environment" { type = string }
variable "region" { type = string }

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network-${var.environment}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_linux_vm" {
  name          = "subnet-linux-${var.environment}"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-portfolio-${var.environment}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["linux-vm"]
}

output "vpc_id" { value = google_compute_network.vpc_network.id }
output "subnet_id" { value = google_compute_subnetwork.subnet_linux_vm.id }