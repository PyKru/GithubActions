param storageNamePrefix string
param acr_name string = 'techsckoolacr'
param asb_name string = 'techsckoolasb'
param app_name string = 'tecjsckoolapp'

var asp_name = 'ASP-{app_name}'
param location string = resourceGroup().location

var stgacc_name = '${storageNamePrefix}${uniqueString(resourceGroup().id)}'

resource storage_account 'Microsoft.Storage/storageAccounts@2022-05-01' ={
  name: stgacc_name
  location: location
  sku: {
    name:  'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource container_registry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: acr_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource asb 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: asb_name
  location: location
}

// Convert ARM to Bicep
// az bicep decompile -file azuredeploy.json

// Convert Bicep to ARM
// az bicep build --file .\keyvault.bicep

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: asp_name
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
}

resource webapp 'Microsoft.Web/sites@2018-11-01' = {
  name: app_name
  location: location
  tags: null
  properties: {
    serverFarmId: asp.id
    clientAffinityEnabled: false
    httpsOnly: true
  }
  dependsOn: []
}
