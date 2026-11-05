# Modular GCP Architecture
This project demonstrates DRY (Don't Repeat Yourself) principles by separating Terraform configurations into logical modules.

## Architecture
* **`main.tf`**: The root environment caller.
* **`modules/network/`**: Creates the VPC, Subnet, and Firewall. Outputs `vpc_id` and `subnet_id`.
* **`modules/compute/`**: Provisions the Compute Engine instance using the network outputs.

**Deployment:**
`terraform apply -var-file="dev.tfvars"`