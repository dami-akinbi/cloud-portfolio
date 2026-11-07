# Load Balancing & Autoscaling: Azure VMSS
This module transitions the architecture from single virtual machines to a highly available Virtual Machine Scale Set (VMSS) behind a Standard Load Balancer.

## Architecture
* **Standard Load Balancer**: Distributes incoming HTTP traffic (Port 80) across the backend pool using a TCP health probe.
* **Virtual Machine Scale Set**: Deploys a baseline of 2 instances in the backend pool.
* **Bootstrapping**: Uses `customData` to automatically install the Nginx web server upon instance creation to validate load balancer routing.

**Deployment:**
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`