variable "environment" { type = string }
variable "region" { type = string }
variable "machine_type" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }

resource "google_compute_instance_template" "ubuntu_template" {
  name_prefix  = "template-ubuntu-${var.environment}-"
  machine_type = var.machine_type
  region       = var.region
  tags         = ["linux-vm", "allow-health-check"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
  }

  metadata_startup_script = "#!/bin/bash\napt-get update\napt-get install -y nginx"

  lifecycle { create_before_destroy = true }
}

resource "google_compute_health_check" "http_hc" {
  name               = "hc-http-${var.environment}"
  check_interval_sec = 14
  tcp_health_check { port = 80 }
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "mig-portfolio-${var.environment}"
  region             = var.region
  base_instance_name = "vm-ubuntu"

  version {
    instance_template = google_compute_instance_template.ubuntu_template.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_hc.id
    initial_delay_sec = 120
  }
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "autoscaler-portfolio-${var.environment}"
  region = var.region
  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization { target = 0.7 }
  }
}

output "mig_instance_group" { value = google_compute_region_instance_group_manager.mig.instance_group }
output "health_check_id" { value = google_compute_health_check.http_hc.id }
