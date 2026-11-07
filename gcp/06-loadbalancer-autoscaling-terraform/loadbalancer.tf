resource "google_compute_backend_service" "backend" {
  name          = "backend-portfolio-${var.environment}"
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = [module.compute.health_check_id]
  backend {
    group = module.compute.mig_instance_group
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "urlmap-portfolio-${var.environment}"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "proxy-portfolio-${var.environment}"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name                  = "fr-portfolio-${var.environment}"
  target                = google_compute_target_http_proxy.http_proxy.id
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
}
