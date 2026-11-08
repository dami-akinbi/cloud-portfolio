# Serverless Architecture: GCP Cloud Functions
This module provisions a highly scalable, event-driven HTTP Cloud Function. It uses Terraform's `archive_file` data source to dynamically package and upload the Node.js source code during deployment.

## Architecture
* **Cloud Storage Bucket**: A uniform-access bucket that acts as the staging area for the zipped source code.
* **Cloud Function**: A Node.js 20 endpoint configured with an HTTP trigger and 128MB of memory.
* **IAM Invoker**: Configured to allow unauthenticated public execution for testing purposes.

**Deployment:**
`terraform apply -var-file="dev.tfvars"`