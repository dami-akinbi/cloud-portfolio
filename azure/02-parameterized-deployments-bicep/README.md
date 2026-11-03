# Parameterized Azure Deployments
This module uses Bicep parameters to deploy environment-specific infrastructure (Dev/Prod) from a single codebase.

**Deployment Command:**
`az group create --name rg-portfolio-dev --location uksouth`
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`