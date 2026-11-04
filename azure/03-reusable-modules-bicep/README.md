# Modular Azure Architecture
This project refactors the foundational Azure Bicep deployments into independent, reusable modules. 

## Architecture
* **`main.bicep`**: The root orchestrator.
* **`modules/network.bicep`**: Provisions the Virtual Network, Subnets, and NSG. Passes the `subnetId` as an output.
* **`modules/compute.bicep`**: Provisions the Public IP, NIC, and Ubuntu Virtual Machine, attaching to the injected `subnetId`.

**Deployment:**
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`