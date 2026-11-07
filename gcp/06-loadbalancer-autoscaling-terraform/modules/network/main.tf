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

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["linux-vm"]
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-hc-portfolio-${var.environment}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  # These are Google's official IP ranges for Load Balancer Health Checks
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
}

resource "google_compute_router" "router" {
  name    = "router-portfolio-${var.environment}"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-portfolio-${var.environment}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

output "vpc_id" { value = google_compute_network.vpc_network.id }
output "subnet_id" { value = google_compute_subnetwork.subnet_linux_vm.id }