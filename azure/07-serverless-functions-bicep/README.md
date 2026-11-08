# Serverless Architecture: Azure Functions
This module provisions an event-driven serverless compute backend using the Node.js runtime, ensuring infrastructure scales to zero when idle.

## Architecture
* **Storage Account**: Stores the function's execution code, state, and triggers.
* **Consumption Plan**: The true serverless hosting tier (Dynamic `Y1`), billing strictly per millisecond of execution.
* **Function App**: The compute resource configured with the Node.js worker runtime and linked to the storage backend.

**Deployment:**
`az deployment group create --resource-group rg-portfolio-dev --template-file main.bicep --parameters parameters.dev.json`