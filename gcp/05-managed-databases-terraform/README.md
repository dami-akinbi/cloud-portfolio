# Managed Databases: GCP Cloud SQL
This module deploys a Google Cloud SQL instance for PostgreSQL, ensuring secure, managed database hosting.

## Architecture
* **Cloud SQL Instance**: Configured with `db-f1-micro` for development cost-efficiency.
* **Database User**: Deploys an administrative user with a dynamically injected, sensitive password.

**Deployment:**
`terraform apply -var-file="dev.tfvars" -var="db_password=YourSecurePassword123!"`