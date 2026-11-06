variable "environment" { type = string }
variable "region" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}

resource "google_sql_database_instance" "postgres" {
  name             = "psql-portfolio-${var.environment}"
  database_version = "POSTGRES_15"
  region           = var.region
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false 
}

resource "google_sql_user" "db_admin" {
  name     = "pgadmin"
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}