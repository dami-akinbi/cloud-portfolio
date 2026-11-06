variable "project_id" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "environment" { type = string }
variable "machine_type" { type = string }

variable "db_password" {
  type      = string
  sensitive = true
}