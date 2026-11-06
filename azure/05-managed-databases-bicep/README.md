# Managed Databases: Azure PostgreSQL Flexible Server
This module integrates a Platform-as-a-Service (PaaS) database into the architecture, offloading OS maintenance and patching to Azure.

## Architecture
* **PostgreSQL Flexible Server**: Provisioned using the `Standard_B1ms` burstable tier.
* **Firewall Rule**: Configured to allow internal traffic from other Azure resources.

**Deployment:**
(Requires passing the secure password at runtime)
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json --parameters dbAdminPassword="YourSecurePassword123!"`