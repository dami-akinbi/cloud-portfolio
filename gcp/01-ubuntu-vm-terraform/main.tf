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

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-portfolio"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["linux-vm"]
}

resource "google_compute_instance" "ubuntu_vm" {
  name         = "vm-ubuntu-portfolio"
  machine_type = "e2-micro"
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