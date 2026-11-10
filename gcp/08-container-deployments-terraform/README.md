# Container Deployments: GCP Cloud Run
This module provisions a fully managed serverless container deployment using Google Cloud Run. It provides an automatic HTTPS endpoint and scales from zero based on traffic.

## Architecture
* **Cloud Run Service (v2)**: Pulls and runs the `nginx:latest` Docker image, explicitly routing incoming traffic to container port 80.
* **IAM Invoker Policy**: Grants `roles/run.invoker` to `allUsers`, allowing unauthenticated public internet access to the web server.

**Deployment:**
`terraform apply -var-file="dev.tfvars"`

*Note: Managed via GitHub Actions CI/CD.*