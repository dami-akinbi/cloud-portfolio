param environment string
param location string = resourceGroup().location

// Log Analytics Workspace (The central hub for all monitoring data)
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-portfolio-${environment}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018' // Standard pay
    }
    retentionInDays: 30 // Cost optimization: Only keep logs for 30 days
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
