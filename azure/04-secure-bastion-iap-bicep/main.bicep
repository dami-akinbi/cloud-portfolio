param environment string
param location string = resourceGroup().location
param vmSize string
@secure()
param adminPassword string

// 1. Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-portfolio-${environment}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH-Internal'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.0.2.0/24' // Only allow SSH from the Bastion subnet
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// 2. Virtual Network with VM Subnet AND Bastion Subnet
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-portfolio-${environment}'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.1.0/24'] }
    subnets: [
      {
        name: 'subnet-linux-${environment}'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: { id: nsg.id }
        }
      }
      {
        name: 'AzureBastionSubnet' // This exact name is required by Azure
        properties: { addressPrefix: '10.0.2.0/24' }
      }
    ]
  }
}

// 3. Bastion Public IP (Standard SKU required)
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-bastion-${environment}'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

// 4. Azure Bastion Host
resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: 'bastion-portfolio-${environment}'
  location: location
  sku: { name: 'Basic' }
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: { id: vnet.properties.subnets[1].id } // Reference the Bastion subnet
          publicIPAddress: { id: bastionPip.id }
        }
      }
    ]
  }
}

// 5. Private NIC (No Public IP)
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'nic-portfolio-${environment}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: { id: vnet.properties.subnets[0].id } // Reference the VM subnet
        }
      }
    ]
  }
}

// 6. Ubuntu VM
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'vm-ubuntu-portfolio-${environment}'
  location: location
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
    networkProfile: { networkInterfaces: [{ id: nic.id }] }
  }
}
