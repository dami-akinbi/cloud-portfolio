variable "project_id" { type = string }
variable "environment" { type = string }
variable "region" {
  type    = string
  default = "us-central1"
}
variable "machine_type" {
  type    = string
  default = "e2-micro"
}
