# Container Deployments: Azure Container Instances (ACI)
This module provisions a lightweight, serverless container environment to run a web application without managing underlying virtual machines.

## Architecture
* **Azure Container Instance (ACI)**: Deploys the official `nginx:latest` Docker image.
* **Networking**: Configured with a public IP address and a dynamically generated Fully Qualified Domain Name (FQDN) for direct browser access.
* **Compute Resources**: Allocated 1 CPU core and 1 GB of memory.

**Deployment:**
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`

*Note: This architecture is automatically deployed via GitHub Actions CI/CD.*