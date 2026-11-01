# Multicloud Infrastructure Portfolio

This repository serves as a centralized collection of my hands-on cloud engineering projects, demonstrating Infrastructure as Code (IaC) principles across major cloud providers. The goal of these deployments is to transition from manual portal configurations to scalable, automated infrastructure using Bicep, Terraform, and ARM templates.

## Current Project: Azure Secure Network Foundation

The initial phase of this portfolio establishes a secure networking foundation in Microsoft Azure using Bicep. 

### Architecture Details
* **Virtual Network (VNet):** Configured with a `10.0.0.0/16` address space (`vnet-portfolio-iac`).
* **Subnet:** Dedicated `10.0.1.0/24` block isolated for virtual machine deployments.
* **Network Security Group (NSG):** Attached to the subnet with explicit inbound rules allowing SSH (Port 22) to support a secure Linux Virtual Machine environment.

### Deployment Stack
* **Cloud Provider:** Microsoft Azure
* **IaC Tool:** Azure Bicep
* **Execution:** Azure CLI locally authenticated via VS Code

## Future Roadmap
* **Google Cloud Platform (GCP):** Introduce parallel deployments utilizing Terraform to provision VPCs and Compute Engine instances.
* **Automation:** Implement CI/CD pipelines via GitHub Actions for automated infrastructure validation.