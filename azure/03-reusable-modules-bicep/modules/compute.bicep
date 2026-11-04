param locaation string
param environment string
param subnetId string
param vmSize string
param adminUsername string
@secure()
param adminPassword string

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-portfolio-${environment}'
  location: locaation
  properties: { publicIPAllocationMethod: 'Dynamic' }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-portfolio-${environment}'
  location: locaation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: publicIp.id }
          subnet: { id: subnetId }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-portfolio-${environment}'
  location: locaation
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: 'ubuntu-vm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: { createOption: 'FromImage' }
    }
    networkProfile: {
      networkInterfaces: [ { id: nic.id } ]
    }
  }
}
