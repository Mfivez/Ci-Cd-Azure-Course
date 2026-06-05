@description('Nom de base utilisé pour les ressources Azure.')
param namePrefix string = 'croissantdemo'

@description('Région Azure.')
param location string = resourceGroup().location

@description('Tag Docker initial utilisé par App Service.')
param initialImageTag string = '1'

var acrName = toLower('${namePrefix}acr')
var planName = '${namePrefix}-plan'
var devAppName = '${namePrefix}-dev'
var prodAppName = '${namePrefix}-prod'
var imageRepository = 'croissant-api'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource devApp 'Microsoft.Web/sites@2023-12-01' = {
  name: devAppName
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageRepository}:${initialImageTag}'
      appSettings: [
        { name: 'WEBSITES_PORT', value: '8080' }
        { name: 'ENVIRONMENT_NAME', value: 'dev' }
        { name: 'APP_VERSION', value: initialImageTag }
        { name: 'LOG_LEVEL', value: 'debug' }
      ]
    }
  }
}

resource prodApp 'Microsoft.Web/sites@2023-12-01' = {
  name: prodAppName
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageRepository}:${initialImageTag}'
      appSettings: [
        { name: 'WEBSITES_PORT', value: '8080' }
        { name: 'ENVIRONMENT_NAME', value: 'production' }
        { name: 'APP_VERSION', value: initialImageTag }
        { name: 'LOG_LEVEL', value: 'info' }
      ]
    }
  }
}

resource stagingSlot 'Microsoft.Web/sites/slots@2023-12-01' = {
  name: 'staging'
  parent: prodApp
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageRepository}:${initialImageTag}'
      appSettings: [
        { name: 'WEBSITES_PORT', value: '8080' }
        { name: 'ENVIRONMENT_NAME', value: 'staging' }
        { name: 'APP_VERSION', value: initialImageTag }
        { name: 'LOG_LEVEL', value: 'debug' }
      ]
    }
  }
}

output acrLoginServer string = acr.properties.loginServer
output devAppName string = devApp.name
output prodAppName string = prodApp.name
output stagingUrl string = 'https://${prodApp.name}-staging.azurewebsites.net'
