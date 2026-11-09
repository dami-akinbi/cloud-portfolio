param environment string
param location string = resourceGroup().location

// Azure Container Instance Group
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: 'ci-portfolio-${environment}-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    osType: 'Linux'
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      ports: [
        { port: 80, protocol: 'TCP' }
      ]
      // Generate a unique domain name so we can access it via browser
      dnsNameLabel: 'ci-portfolio-${environment}-${uniqueString(resourceGroup().id)}'
    }
    containers: [
      {
        name: 'nginx-container'
        properties: {
          image: 'nginx:latest'
          ports: [
            {
              port: 80
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
        }
      }
    ]
  }
}

// Output the Fully Qualified Domain Name (FQDN) to the terminal for easy testing 
// output containerFQDN string = containerGroup.properties.ipAddress.fqdn
