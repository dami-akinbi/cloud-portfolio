# Multicloud Infrastructure Portfolio

This repository is a centralized collection of my hands-on cloud engineering projects, demonstrating Infrastructure as Code (IaC) across major cloud providers. The architecture evolves from basic standalone deployments to highly available, modular, and automated enterprise environments.

## ⚙️ Deployment Stack
* **Cloud Providers:** Microsoft Azure, Google Cloud Platform (GCP)
* **IaC Tools:** Bicep, Terraform (HCL)
* **CI/CD:** GitHub Actions
* **Execution:** Azure CLI, gcloud CLI, PowerShell

## 📊 Project Progression
- [x] 01 - Virtual Machines (Ubuntu)
- [x] 02 - Parameterized Deployments
- [x] 03 - Reusable Modules
- [x] 04 - Secure Bastion & IAP
- [x] 05 - Managed Databases
- [x] 06 - Load Balancers & Autoscaling
- [x] 07 - Serverless Functions
- [x] 08 - Container Deployments
- [ ] 09 - GitHub Actions CI/CD
- [ ] 10 - Kubernetes Clusters
- [ ] 11 - Monitoring & Alerting
- [ ] 12 - Hub-and-Spoke Network

## 📂 Project Roadmap

### Phase 1: Foundations & Best Practices
* **01-ubuntu-vm:** Secure network foundation (VNet/VPC, Subnet, NSG/Firewall) and VM provisioning. *(Completed)*
* **02-parameterized-deployments:** Environment segregation using dynamic parameters and variable files.
* **03-reusable-modules:** DRY architecture using independent, callable network and compute modules.
* **04-secure-bastion-iap:** Eliminating public IPs by implementing secure remote access via Azure Bastion and GCP IAP.

### Phase 2: Scalability & Managed Services
* **05-managed-databases:** Provisioning PaaS PostgreSQL instances with private endpoints.
* **06-loadbalancer-autoscaling:** High availability using VM Scale Sets / Managed Instance Groups behind L7 Load Balancers.
* **07-serverless-functions:** Event-driven serverless compute endpoints.
* **08-container-deployments:** Secure serverless container orchestration (Container Instances / Cloud Run).

### Phase 3: Enterprise Architecture & Automation
* **09-github-actions-cicd:** End-to-end CI/CD pipelines for automated IaC planning and deployment.
* **10-kubernetes-cluster:** Foundational deployment of AKS and GKE clusters.
* **11-monitoring-alerting:** Codifying telemetry, log aggregation, and automated alerting.
* **12-hub-and-spoke-network:** Enterprise network topology featuring central hubs, peered spokes, and transitive routing.