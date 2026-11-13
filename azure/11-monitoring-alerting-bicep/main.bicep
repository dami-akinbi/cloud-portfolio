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

// Action Group (who to notify)
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: 'ag-portfolio-${environment}'
  location: 'Global' // Action Groups are global resources
  properties: {
    groupShortName: 'ag-port'
    enabled: true
    emailReceivers: [
      { 
        name: 'admin-email'
        emailAddress: 'akinbidamilola074@gmail.com'
        useCommonAlertSchema: true
      }
    ]
  }
}
output actionGroupId string = actionGroup.id

// Alert Rule (when to notify)
resource logAlert 'Microsoft.Insights/scheduledQueryRules@2023-12-01' = {
  name: 'alert-heartbeat-${environment}'
  location: location
  properties: {
    description: 'Alert on missing heartbeats'
    enabled: true
    scopes: [ logAnalyticsWorkspace.id ]
    evaluationFrequency: 'PT5M' // Check every 5 minutes
    windowSize: 'PT5M' // Look at the last 5 minutes of data
    
    criteria: {
      allOf: [
        {
          query: 'Heartbeat | summarize Count() by Computer'
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 10
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }

    actions: {
      actionGroups: [ actionGroup.id ]
    }
  }
}
