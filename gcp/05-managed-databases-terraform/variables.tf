variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "environment" { type = string }
variable "machine_type" { type = string }

module "database" {
  source  = "./modules/database"
  environment = var.environment
  region      = var.region
  db_password = var.db_password
}

variable "db_password" {
  type      = string
  sensitive = true
}