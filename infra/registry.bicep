@description('Azure region for the registry.')
param location string = resourceGroup().location

@minLength(1)
@maxLength(16)
@description('Short environment name used in resource names.')
param environmentName string = 'prod'

var acrName = replace('marmalade${environmentName}${uniqueString(resourceGroup().id)}', '-', '')

resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
