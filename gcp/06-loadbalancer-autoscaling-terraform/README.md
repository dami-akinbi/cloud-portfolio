# Load Balancing & Autoscaling: GCP Managed Instance Groups
This module demonstrates high availability by chaining an HTTP Global Load Balancer to a regional Managed Instance Group (MIG) with dynamic autoscaling.

## Architecture
* **Global Load Balancer**: Composed of a Forwarding Rule, Target HTTP Proxy, URL Map, and Backend Service.
* **Instance Template & MIG**: Bootstraps Ubuntu instances with Nginx and attaches them to the backend service.
* **Autoscaler**: Configured to scale between 1 and 3 instances based on a 70% CPU utilization target.

**Deployment:**
`terraform apply -var-file="dev.tfvars"`