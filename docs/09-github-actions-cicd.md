# Project 09: GitHub Actions CI/CD Pipelines

Automated Infrastructure as Code (IaC) deployment workflows for Azure and GCP using GitHub Actions.

## Workflows
* **Azure CD (`.github/workflows/azure-deploy.yml`)**:
  * **Trigger**: Pushes to `azure/**` path on `main` branch.
  * **Auth**: Azure Service Principal authenticated via `AZURE_CREDENTIALS` repository secret.
  * **Execution**: Automated `azure/arm-deploy@v1` using Bicep.

* **GCP CD (`.github/workflows/gcp-deploy.yml`)**:
  * **Trigger**: Pushes to `gcp/**` path on `main` branch.
  * **Auth**: GCP Service Account JSON key authenticated via `GCP_CREDENTIALS` repository secret.
  * **Execution**: `hashicorp/setup-terraform` executing `terraform init` and `terraform apply -auto-approve`.

## Security & Secrets Management
* Service credentials scoped to dev environments (`rg-portfolio-dev` and `damis-project-01`).
* Zero long-lived credentials stored in source control.