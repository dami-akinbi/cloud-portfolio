param environment string
param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string

// 1. Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'vnet-portfolio-${environment}'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [{ name: 'subnet-vmss-${environment}', properties: { addressPrefix: '10.0.1.0/24'} }]
  }
}

// 2. Load Balancer Public IP
resource lbPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'pip-lb-${environment}'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

// 3. Standard Load Balancer
resource lb 'Microsoft.Network/loadBalancers@2023-09-01' = {
  name: 'lb-portfolio-${environment}'
  location: location
  sku: { name: 'Standard' }
  properties: {
    frontendIPConfigurations: [{ name: 'FrontendConfig', properties: { publicIPAddress: { id: lbPip.id } } }]
    backendAddressPools: [{ name: 'BackendPool' }]
    loadBalancingRules: [{
      name: 'HttpRule'
      properties: {
        frontendIPConfiguration: { id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', 'lb-portfolio-${environment}', 'FrontendConfig') }
        backendAddressPool: { id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'lb-portfolio-${environment}', 'BackendPool') }
        probe: { id: resourceId('Microsoft.Network/loadBalancers/probes', 'lb-portfolio-${environment}', 'HttpHealthProbe') }
        protocol: 'Tcp'
        frontendPort: 80
        backendPort: 80
      }
    }]
  }
}

// 4. Virtual Machine Scale Set (VMSS)
resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2023-09-01' = {
  name: 'vmss-portfolio-${environment}'
  location: location
  sku: { name: 'Standard_B1s', capacity: 2 }
  properties: {
    overprovision: false
    upgradePolicy: { mode: 'Manual' }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: 'vmss'
        adminUsername: adminUsername
        adminPassword: adminPassword
        // Automatically installs Nginx on boot so we can test the Load Balancer 
        // customData: base64('#!/bin/bash\napt-get update\napt-get install -y nginx')
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
        networkInterfaceConfigurations: [{
          name: 'nic-vmss'
          properties: {
            primary: true
            ipConfigurations: [{
              name: 'ipconfig'
              properties: {
                subnet: { id: vnet.properties.subnets[0].id }
                loadBalancerBackendAddressPools: [{ id: lb.properties.backendAddressPools[0].id }]
              }
            }]
          }
        }]
      }
    }
  }
}
