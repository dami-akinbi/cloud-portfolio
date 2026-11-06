# Secure Remote Access: GCP Identity-Aware Proxy (IAP)
This module demonstrates secure, public-IP-less infrastructure by routing SSH traffic exclusively through Google's Identity-Aware Proxy forwarding servers.

## Architecture
* **Firewall (`allow_ssh`)**: Strictly limits ingress to Google's IAP IP block (`35.235.240.0/20`).
* **Compute Engine**: Provisioned without an `access_config` block, ensuring no public IP is attached.

**Deployment:**
`terraform apply -var-file="dev.tfvars"`