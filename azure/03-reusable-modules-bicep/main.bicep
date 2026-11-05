param environment string
param location string = resourceGroup().location
param vmSize string
param adminUsername string
@secure()
param adminPassword string

module network 'modules/network.bicep' = {
  name: 'networkModuleDeployment'
  params: {
    location: location
    environment: environment
  }
}

module compute 'modules/compute.bicep' = {
  name: 'computeModuleDeployment'
  params: {
    locaation: location
    environment: environment
    subnetId: network.outputs.subnetId
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
