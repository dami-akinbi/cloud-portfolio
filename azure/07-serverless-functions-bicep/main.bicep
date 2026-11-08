param environment string
param location string = resourceGroup().location

// Storage Account have strict naming rules: lowercase, no dashes, max 24 characters.
var storageAccountName = toLower('stport${environment}-${uniqueString(resourceGroup().id)}')
var functionAppName = 'func-portfolio-${environment}-${uniqueString(resourceGroup().id)}'

// 1. Storage Account (Required by Azure Functions to manage state and triggers)
resource storageAccount 'Microsoft.Storage/storageAccount@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

// 2. Application Insights (Enterprise logging and telemetry)
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-portfolio-${environment}'
  location: location
  kind: 'web'
  properties: { Application_Type: 'web' }
}

// 3. Consumption Plan (The services engine and billing tier)
resource hostingPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'plan-portfolio-${environment}'
  location: location
  sku: {
    name: 'Y1' // Y1 designates the dynamic Serverless Consumption tier
    tier: 'Dynamic'
  }
  properties: {}
}

// 4. Function App
resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${az.environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node' // Pre-configures the environment for Node.js functions
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
      ]
    }
  }
}
