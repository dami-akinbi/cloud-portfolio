param location string
param environment string

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-portfolio-${environment}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-portfolio-${environment}'
  location: location
  properties: {
    addressPrefixes: '10.0.1.0/24'
    networkSecurityGroup: { id: nsg.id }
  }
}

output subnetId string = vnet.properties.subnets[0].id
