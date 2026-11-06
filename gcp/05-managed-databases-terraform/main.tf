provider "google" {
  project = var.project_id
  region  = var.region
}

module "network" {
  source      = "./modules/network"
  environment = var.environment
  region      = var.region
}

module "compute" {
  source       = "./modules/compute"
  environment  = var.environment
  region       = var.region
  machine_type = var.machine_type
  vpc_id       = module.network.vpc_id
  subnet_id    = module.network.subnet_id
}