variable "environment" { type = string }
variable "region" { type = string }
variable "machine_type" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }

resource "google_compute_instance" "ubuntu_vm" {
  name         = "vm-ubuntu-portfolio-${var.environment}"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  tags         = ["linux-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
    access_config {
      // Ephemeral public IP
    }
  }
}