provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-portfolio-${var.environment}"
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
  target_tags = ["linux-vm"]
}

resource "google_compute_instance" "ubuntu_vm" {
  name         = "vm-ubuntu-portfolio-${var.environment}"
  machine_type = var.machine_type
  zone         = "us-central1-a"

  tags = ["linux-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet_linux_vm.id
    access_config {
      # leaving this empty assigns an ephemeral Publi IP
    }
  }
}