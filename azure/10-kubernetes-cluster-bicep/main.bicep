param environment string
param location string = resourceGroup().location

// Managed Kubernetes Cluster (AKS)
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-08-01' = {
  name: 'aks-portfolio-${environment}'
  location: location
  identity: {
    type: 'SystemAssigned' // AKS automatically manages its own identity/permissions
  }
  properties: {
    dnsPrefix: 'aks-portfolio-${environment}'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_B2ps_v2' // Updated VM size
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

output aksClusterName string = aksCluster.name
