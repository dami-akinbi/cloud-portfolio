# Secure Remote Access: Azure Bastion
This module removes public IPs from virtual machines, deploying an Azure Bastion host to broker secure, browser-based SSH/RDP connections over the Azure backbone.

## Architecture
* **Virtual Network**: Provisioned with a dedicated `AzureBastionSubnet` (/24 minimum).
* **Network Security Group**: Restricted to only allow SSH (Port 22) traffic originating from the Bastion subnet.
* **Ubuntu VM**: Provisioned purely with a private NIC.

**Deployment:**
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`